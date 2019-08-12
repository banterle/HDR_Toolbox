function write_rgbe_line(buffer_line, fid)
%
%       write_rgbe_line(buffer_line, file)
%
%       This function write an image line using RLE and RGBE encoding
%
%        Input:
%           -buffer_line: a color line of an image
%           -file: the outputting file
%
%     Copyright (C) 2014  Francesco Banterle
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

n = length(buffer_line);

cur_pointer = 1;

while(cur_pointer <= n ) 
    run_length = 0;
    run_length_old = 0;
    
    run_start = cur_pointer;
    
    %we need to find a long run; length>3
    while((run_length<4) && (run_start <= n ))
        run_start = run_start + run_length;
        run_length_old = run_length;
        
        i_end = min([run_start + 127 - 1, n]);
              
        run_length = 1;
        
        %finding a run
        for i=(run_start + 1):i_end
            if(buffer_line(run_start) == buffer_line(i))
                run_length = run_length + 1;
            else
                break
            end
        end
    end
    
    %do we have a short run <4 before a long one?
    if((run_length_old > 1) && (run_length_old == (run_start - cur_pointer)))
        length_to_write = run_length_old + 128;
        value_to_write = buffer_line(cur_pointer);
        fwrite(fid, length_to_write, 'uint8');
        fwrite(fid, value_to_write, 'uint8');
        
        cur_pointer = run_start;
    end
    
    %writing non-runs
    while(cur_pointer < run_start)
        non_run_length = run_start - cur_pointer;

        if(non_run_length > 128)
            non_run_length = 128;
        end
        
        fwrite(fid, non_run_length, 'uint8');
        fwrite(fid, buffer_line(cur_pointer : (cur_pointer + non_run_length - 1)), 'uint8');

        cur_pointer = cur_pointer + non_run_length;
    end

    %writing the found long run
    if(run_length > 3)
        length_to_write = run_length + 128;
        value_to_write = buffer_line(run_start);
        fwrite(fid, length_to_write, 'uint8');
        fwrite(fid, value_to_write, 'uint8');

        cur_pointer = cur_pointer + run_length;
    end
    
end

end