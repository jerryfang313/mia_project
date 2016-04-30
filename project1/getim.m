function y = getim(filename)
 fid=fopen(filename);
 if fid > -1
     y=fread(fid,[1024 1024],'char');
     fclose(fid);
     y=y';
 else
     message = 'I/O error:  File could not be opened';
     disp(message);
end