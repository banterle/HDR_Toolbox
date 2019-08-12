function lstOut = pyrLst2OP(lstIn1, lstIn2, fun)
%
%
%        lstOut = pyrLst2OP(lstIn1, lstIn2, fun)
%
%
%        Input:
%           -lstIn1: a list of image pyramids (first operand of fun)
%           -lstIn2: a list of image pyramids (second operand of fun)
%           -fun: a function to apply to lstIn1 and lstIn2
%
%        Output:
%           -lstOut: the result of the function
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

n = length(lstIn1);

lstOut = [];

for i=1:n
    p = fun(lstIn1(i), lstIn2(i));
    lstOut = [lstOut, p];
end

end