function gamma_value = KuangGamma(average_surrond_param)
%
%
%       gamma_value = KuangGamma(average_surrond_param)
%
%       Input:
%           -average_surrond_param: 
%               'dark':
%               'average':
%               'dim':
%
%       Output:
%           -gamma_value: a gamma value.
% 
%     Copyright (C) 2015  Francesco Banterle
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     The paper describing this technique is:
%     "iCAM06: A refined image appearance model for HDR image rendering"
% 	  by Jiangtao Kuang, Garrett M. Johnson, and Mark D. Fairchild
%     in J. Vis. Commun. Image R. 18 (2007) 406–-414
%

switch average_surrond_param
    case 'dark'
        gamma_value = 1.5;
        
    case 'dim'
        gamma_value = 1.25;
        
    case 'average'
        gamma_value = 1.0;
        
    otherwise
        gamma_value = 1.0;
end

end