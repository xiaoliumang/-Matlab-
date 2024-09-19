function [ mhd ] = ModHausdorffDist( A,B )  

Asize = size(A);  
Bsize = size(B);  

if Asize(2) ~= Bsize(2)  
    msgbox('�������ϵ�ά����ͬ����ͳһ��', '��ʾ');
else
 
    fhd = 0;                  
    for a = 1:Asize(1)        
        mindist = Inf;         
        for b = 1:Bsize(1)     
            tempdist = norm(A(a,:)-B(b,:));  
            if tempdist < mindist  
                mindist = tempdist;  
            end  
        end  
        fhd = fhd + mindist;   
    end  
    fhd = fhd/Asize(1);         

    rhd = 0;                  
    for b = 1:Bsize(1)         
        mindist = Inf;         
        for a = 1:Asize(1)   
            tempdist = norm(A(a,:)-B(b,:));  
            if tempdist < mindist  
                mindist = tempdist;  
            end  
        end  
        rhd = rhd + mindist;   
    end  
    rhd = rhd/Bsize(1);     

    mhd = max(fhd,rhd);       
                        
end

end

