star(36,5,6);

module star(N=5, ri=15, re=30) {
    polygon([
        for (n = [0 : N-1], in = [true, false])
            in ? 
                [ri*cos(-360*n/N + 360/(N*2)), ri*sin(-360*n/N + 360/(N*2))] :
                [re*cos(-360*n/N), re*sin(-360*n/N)]
    ]);
}
