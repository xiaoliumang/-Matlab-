function FD = fourierdescriptors(pic)
  numcoeffs = 7; 
  q = fft2(pic);    
  normalizationfactor = abs(q(1)); 
  q = q(2:1+numcoeffs);
  q = abs(q);
  FD = q/normalizationfactor; 
end
