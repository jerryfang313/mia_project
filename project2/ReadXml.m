% function [outVol param]=ReadXml(inVolName)
%
% Input inVolName is a .xml file path (full) containing dimension, type etc information of the 
% input volume. The .raw file should be at the same location of input xml
% file. param.res=resolution

function [outVol param]=ReadXml(inVolName)
%inVolName
xDoc=xmlread(inVolName);
t1=xDoc.getElementsByTagName('Data-type');
type=t1.item(0).getFirstChild.getData.toCharArray;
type=type';
param.type=type;

if strcmp(type,'unsigned byte')
    type='uint8';
elseif strcmp(type,'Unsigned Byte')
    type='uint8';
elseif strcmp(type,'float')
    type='float32';
elseif strcmp(type,'Float')
    type='float32';
elseif strcmp(type,'unsigned short')
    type='ushort';
elseif strcmp(type,'Unsigned Short')
    type='ushort';
elseif strcmp(type,'short')
    type='short';
elseif strcmp(type,'Short')
    type='short';
elseif strcmp(type,'Byte')
    type='int8';
elseif strcmp(type,'Integer')
    type='int32';
elseif strcmp(type,'Unsigned Integer')
    type='uint32';
elseif strcmp(type,'integer')
    type='int32';
elseif strcmp(type,'Double')
    type='double';
elseif strcmp(type,'double')
    type='double';
end
rtype = type;

if strcmp(type,'Boolean')
    rtype='uint8';
    type = 'Boolean'
elseif strcmp(type,'boolean')
    rtype='uint8';
    type = 'Boolean'
end 

t2=xDoc.getElementsByTagName('Endianess');
e=t2.item(0).getFirstChild.getData.toCharArray;
e=e(1);
e=lower(e);
t3=xDoc.getElementsByTagName('Extents');
numdims=t3.getLength();
for i=0:(numdims-1)
    S=t3.item(i).getFirstChild.getData.toCharArray;
    N1(i+1)=str2num(S');
end

% Get resolution
tr=xDoc.getElementsByTagName('Resolution');
res = ones(1,numdims);
for i=0:min(numdims-1,2)
    res(i+1)=str2num(tr.item(i).getFirstChild.getData);
end

% Get orientation params
t2=xDoc.getElementsByTagName('Orientation');
orient=(t2.item(0).getFirstChild.getData.toCharArray)';

t2=xDoc.getElementsByTagName('Subject-axis-orientation');
for i=0:min(numdims-1,2)
    S=(t2.item(i).getFirstChild.getData.toCharArray)';
    axisOrient{i+1}=S;
end

if(numdims==3)
   fprintf('Size of input volume=[%d %d %d],type=%s\n',N1(1),N1(2),N1(3),type); 
elseif(numdims==4)
    fprintf('Size of input volume=[%d %d %d %d],type=%s\n',N1(1),N1(2),N1(3), N1(4),type); 
end

volname=inVolName(1:end-4);
Involname=strcat(volname,'.raw');
readtype = [rtype,'=>',rtype];
try
    fp1=fopen(Involname,'r');
    if strcmp(e,'l')
        outVol=fread(fp1,readtype,'l');
        param.endian='little';
    elseif strcmp(e,'b')
        outVol=fread(fp1,readtype,'b');
        param.endian='big';
    else
        fprintf('unknown type, check xml file for Endianness\n');
        return;
    end
catch
    disp('read error');
    rethrow(lasterror);
end
try
    fclose(fp1);
catch
    disp('close error');
    rethrow(lasterror);
end

if(strcmp(type,'Boolean') || strcmp(type,'boolean'))
    disp('generating boolean')
    outVol = uchar2Boolean(outVol);
end


outVol=reshape(outVol,N1);

% set all params
param.dim=N1;
param.res=res;
param.orientation=orient;
param.axisOrientation=axisOrient;
