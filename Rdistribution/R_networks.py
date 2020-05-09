import scipy.io as sio
import numpy as np
import random as rand

# Loading network data
mat = sio.loadmat('optimalNetwork.mat')
W = mat['A_norm_max_inh'].astype(float)
N = len(W)
V = np.load('V_weights.npy').flatten()

# seed for random number generation
seed = 2000
np.random.seed(seed)
rand.seed(seed)


# simulate dynamics function
def simulation(time, V, W, external_input):
    X = np.zeros([N, time + 1])
    X[:, 0] = np.random.rand(N) * 2 - 1
    for t in range(0, time):
        X[:, t + 1] = np.tanh(V * external_input[t] + np.dot(W, X[:, t]))
    return X


# apply inhibition randomly
def random_inhibition(A, n):
    newA = np.abs(np.copy(A))
    inhi_pos = rand.sample(range(0, len(A)), n)
    for i in inhi_pos:
        newA[i, :] = -newA[i, :]
    return newA, inhi_pos


# check applied inhibition
def check_inhibition(A):
    sumA = np.sum(A, 1)
    return sum(sumA < 0)


# parameters
time = 500
pulses_amount = 20  # pulses
wid = 0.01  # histogram width
duration = 8  # pulse duration
t0 = 15  # time before first pulse
t = 10  # time for 0 state
std = 2  # variation for pulses length in range [-2,2]

# uncomment to apply desired inhibition
# inhibition = 0.05
# W,inhi_pos = random_inhibition(W, round(0.05 * len(W)))

# generate input
input_pulses = np.zeros(t0)
pulseirr_number = np.zeros(t0)
number = 1
while len(input_pulses) < time:
    suplementary = rand.randrange(-std, std, 1)
    input_pulses = np.append(input_pulses, np.ones(duration + suplementary))
    input_pulses = np.append(input_pulses, np.zeros(t))
    pulseirr_number = np.append(pulseirr_number, np.zeros(duration + suplementary))
    pulseirr_number = np.append(pulseirr_number, number * np.ones(t))
    number = number + 1

if len(input_pulses) > time:
    aux = time - len(input_pulses)
    input_pulses = input_pulses[:aux]
elif len(input_pulses) < time:
    aux = time - len(input_pulses)
    input_pulses = np.append(input_pulses, np.zeros(aux))

# uncomment to save data
# if inhibition in locals():
    # results = open("Rdistro"+str(100*inh)+".csv",'w+')
# else:
    # results = open('Rdistro.csv','w+')

meanR = []

for iR in range(1000):

    np.random.seed(1000 + iR)
    rand.seed(1000 + iR)

    # dynamics for intraseries
    iterations = 53
    response_intraseries = np.zeros([pulses_amount, t, N, iterations])
    for j in range(0, iterations):
        out_pulsesirr = simulation(time, V, W, input_pulses)
        for z in range(1, pulses_amount + 1):
            indexes = np.where(pulseirr_number == z)[0] + 1
            for n in range(N):
                response_intraseries[z - 1, :, n, j] = out_pulsesirr[n, indexes]

    # normalizing intraseries dynamics
    for i in range(response_intraseries.shape[3]):
        for n in range(response_intraseries.shape[2]):
            npmean = np.mean(response_intraseries[:, :, n, i], 1).reshape(response_intraseries[:, :, n, i].shape[0], 1)
            npstd = np.std(response_intraseries[:, :, n, i], 1).reshape(response_intraseries[:, :, n, i].shape[0], 1)
            response_intraseries[:, :, n, i] = (response_intraseries[:, :, n, i] - npmean) / npstd

    # compute intraseries correlations
    intraseries_corr = []
    for n in range(response_intraseries.shape[2]):
        intra_corr_neuron = []
        for i in range(response_intraseries.shape[3]):
            corr_mat = np.triu(np.corrcoef(response_intraseries[:, :, n, i]), 1).flatten()
            index = np.where(corr_mat == 0)
            corr_vec = np.delete(corr_mat, index).tolist()
            intra_corr_neuron = intra_corr_neuron + corr_vec
        intraseries_corr.append(np.asarray(intra_corr_neuron))

    # computing dynamics for interseries
    iterations = 500
    response_interseries = np.zeros([iterations, t, pulses_amount, N])
    for j in range(0, iterations):
        out_pulsesirr = simulation(time, V, W, input_pulses)
        for n in range(N):
            for p in range(0, pulses_amount):
                indexes = np.where(pulseirr_number == p + 1)[0] + 1
                response_interseries[j, :, p, n] = out_pulsesirr[n, indexes]

    # normalizing dynamics and computing correlations for interseries
    corr_vec_n = []
    for n in range(response_interseries.shape[3]):
        corr_vec_p = []
        for p in range(response_interseries.shape[2]):
            npmean = np.mean(response_interseries[:, :, p, n], 1).reshape(response_interseries[:, :, p, n].shape[0], 1)
            npstd = np.std(response_interseries[:, :, p, n], 1).reshape(response_interseries[:, :, p, n].shape[0], 1)
            norm_interseries = (response_interseries[:, :, p, n] - npmean) / npstd
            corr_mat = np.triu(np.corrcoef(norm_interseries), 1).flatten()
            index = np.where(corr_mat == 0)
            corr_vec_p = corr_vec_p + np.delete(corr_mat, index).tolist()
        corr_vec_n.append(corr_vec_p)

    # computing R for all the neurons
    Rvec = []
    for n in range(N):
        interseries_corr_abs = [i for i in corr_vec_n[n] if i > 0]
        intraseries_corr_abs = [i for i in intraseries_corr[n] if i > 0]

        response_intra_distribution, bins_intra = np.histogram(intraseries_corr_abs, bins=np.arange(0, 1 + wid, wid))
        response_inter_distribution, bins_inter = np.histogram(interseries_corr_abs, bins=np.arange(0, 1 + wid, wid))

        response_intra_distribution = response_intra_distribution / np.sum(response_intra_distribution)
        response_inter_distribution = response_inter_distribution / np.sum(response_inter_distribution)

        CDF_intra = np.cumsum(response_intra_distribution)
        CDF_inter = np.cumsum(response_inter_distribution)

        auroc = np.trapz(CDF_intra, CDF_inter)
        Rvec.append(auroc)

    # averagin R over neurons
    meanR.append(np.mean(Rvec))
    # uncomment to write meanR values for Visualizing Final Figures
    # results.write('%f, '%np.mean(Rvec))
    # results.flush()
