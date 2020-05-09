function [ opSequence, opDistribution ] = OPsequence( indata, delay, order )
% @brief OPsequence efficiently [1,2] computes distribution and sequence of ordinal patterns from indata
%        for the given delay and order of ordinal patterns
%
% INPUT 
%   - indata - 1D time series (1 X N points) 
%   - delay  - delay between points in ordinal patterns (delay = 1 means successive points)
%   - order  - order of the ordinal patterns (order + 1 is the number of points in ordinal patterns)
% OUTPUT 
%   - opSequence - sequence of computed ( N-order*delay ) numbers of ordinal patterns
%                  ranging from 0 to ((order + 1)! - 1), where ! stands for factorial
%   - opDistribution - normalised distribution of computed ordinal patterns, i.e.
%                      amount of each ordinal pattern is divided by the total amount
%                      of ordinal patterns (order+1)!, where ! stands for factorial
%
% REFERENCES
% [1] Unakafova, V.A., Keller, K., 2013. Efficiently measuring complexity 
%              on the basis of real-world data. Entropy, 15(10), 4392-4415.
% [2] Keller, K. and Sinn, M., 2005. Ordinal analysis of time series.
%     Physica A: Statistical Mechanics and its Applications, 356(1), pp.114-120.
%
% @author Valentina Unakafova
% @date 24.01.2018
% @email UnakafovaValentina(at)gmail.com

 if ( order > 8 )
   error( 'This version does not support orders > 9 for fast computing due to memory limitation' );
 end
 load( [ 'table' num2str( order ) '.mat' ] );      % the precomputed table
 nPoints    = length( indata ) - order*delay;
 if ( nPoints < 1 )
   error( 'Length of the input time series is not sufficient for the given order and delay');
 end
 opTable    = eval( ['table' num2str( order ) ] ); % table of ordinal patterns 
 order1     = order + 1; 
 orderDelay = order*delay; 
 nPatterns  = factorial( order1 );   % amount of ordinal patterns              
 opDistribution     = zeros( 1, nPatterns ); % distribution of ordinal patterns 
 invNumbers = zeros( 1, order );     % inversion numbers of ordinal pattern
 prevOP     = zeros( 1, delay );     % previous ordinal patterns for 1:opDelay
 opSequence = zeros( 1, nPoints );   % ordinal patterns sequence
 ancNum = nPatterns./factorial( 2:order1 );  % ancillary numbers   
 for iTau = 1:delay 
     cnt = iTau; 
     invNumbers( 1 ) = ( indata( orderDelay + iTau - delay ) >= indata( orderDelay + iTau ) );
     for j = 2:order
         invNumbers( j ) = sum( indata( ( order - j )*delay + iTau ) >= ...
           indata( ( order1 - j )*delay + iTau:delay:orderDelay + iTau ) );
     end        
     opSequence( cnt ) = sum( invNumbers.*ancNum );
     opDistribution( opSequence( cnt ) + 1 ) = opDistribution( opSequence( cnt ) + 1 ) + 1;  
     for j = orderDelay + delay + iTau:delay:nPoints + orderDelay   
         cnt = cnt + delay;                               
         posL = 1; % the position of the next point
         for i = j - orderDelay:delay:j - delay
             if( indata( i ) >= indata( j ) ) 
                 posL = posL + 1; 
             end
         end  
         opSequence( cnt ) = opTable( opSequence( cnt - delay )*order1 + posL );
         opDistribution( opSequence( cnt ) + 1 ) = opDistribution( opSequence( cnt ) + 1 ) + 1;            
     end  
     prevOP( iTau ) = opSequence( cnt );
 end    
 opDistribution = opDistribution/nPoints;