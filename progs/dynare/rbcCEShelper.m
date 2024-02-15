function l = rbcCEShelper(l0,PSI,ETAL,ETAC,GAMMA,c_l,w)
    if ETAC == 1 && ETAL == 1
        % close-form expression
        l = GAMMA/PSI*c_l^(-1)*w/(1+GAMMA/PSI*c_l^(-1)*w);
    else
        % use numerical optimizer        
        l = fsolve(@(L) w*GAMMA*c_l^(-ETAC) - PSI*(1-L)^(-ETAL)*L^ETAC ,...
                   l0, optimset('Display','Final','TolX',1e-12,'TolFun',1e-12));
    end
end