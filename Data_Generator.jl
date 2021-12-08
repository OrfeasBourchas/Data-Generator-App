module Data_Generator

    using Gtk,DelimitedFiles,Random
    function Data_Generator_exe()
        #=
        Initialize the Dictionaries
        ============================================#
        keySet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J","K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "V", "U", "W", "X", "Y", "Z"];
        valueSet = [-2.5:0.2:2.5...];
        valueSet_2 = [0:25...];
        Dict_1 = Dict(keySet[i]=>valueSet[i] for i=1:length(valueSet));
        Dict_2 =  Dict(keySet[i]=>valueSet_2[i] for i=1:length(valueSet_2));
        #=
        Create the Gtk Window with the grid and the Entry,Label AND Buttons
        =#
        win = GtkWindow("Data Generator", 300, 250)
        grid = GtkGrid( hexpand =true, vexpand =true)
        digit =GtkEntry()
        First =GtkEntry()
        Last =GtkEntry()    
        digit_label = GtkLabel("Your last digit")
        First_label = GtkLabel("The first letter of your first name capital")
        Last_label = GtkLabel("The first letter of your last name capital")
        b_reset = GtkButton("Reset")
        set_gtk_property!(b_reset,:tooltip_text,"Clears all text areas")
        b_calculate = GtkButton("Calculate & Generate")
        set_gtk_property!(b_calculate,:tooltip_text,"Calculates & Generates the data")
        Draft_label = GtkLabel("Your initial Draft is...")
        grid[1,1] = digit_label
        grid[1,2] = First_label
        grid[1,3] = Last_label
        grid[1,4] = b_reset
        grid[2,1] = digit
        grid[2,2] = First
        grid[2,3] = Last
        grid[2,4] = b_calculate
        grid[1:2,5] = Draft_label
        set_gtk_property!(grid, :column_homogeneous, true)
        set_gtk_property!(grid, :column_spacing, 15)
        id_1 = signal_connect(b_reset, "clicked") do widgit
            set_gtk_property!(digit,:text,"")
            set_gtk_property!(First,:text,"")
            set_gtk_property!(Last,:text,"")
            set_gtk_property!(Draft_label,:label,"Your initial Draft is...")
        end
        id_2 = signal_connect( b_calculate, "clicked") do widgit
            digit_value = parse(Float64, digit.text[String])
            Firstname_value = First.text[String]
            Lastname_value = Last.text[String]
            Draft_initial = 12 + digit_value*0.5 + 0.1*Dict_1[Firstname_value] + 0.1*Dict_1[Lastname_value]
            set_gtk_property!(Draft_label,:label,string(Draft_initial))

            if Dict_2[Firstname_value]+Dict_2[Lastname_value] < 30
                n_trips = 10;
            else
                n_trips =11;
            end
            Vt = [10.2 11.2 12.2 13.2 14.2 15.2]; 
            CT = [1.8733 1.8538 1.9596 2.1447 2.4884 2.7360];
            Load_per_trip = []
            Lcg = []
            Speed = []
            for ii=1:n_trips
                push!(Load_per_trip, round((-1)^(ii+1)*(10000 .+ 1000*rand(1)[1]),digits =2));
                push!(Lcg, round(80 .+(-1)^(ii+1)*20*rand(1)[1],digits = 2));
                push!(Speed, round(10.7.+4*rand(1)[1],digits = 1));
            
            end
            Load_per_trip =Load_per_trip;
            Lcg = Lcg;
            V = Speed;
            
            Data = [Load_per_trip Lcg Speed];
            writedlm( "Data.txt",  Data, ' ')
        end
        push!(win,grid)
        showall(win)

        
        if !isinteractive()
            @async Gtk.gtk_main()
            Gtk.waitforsignal(win,:destroy)
        end

        
    end
    function julia_main()
        Data_Generator_exe()
    end
end