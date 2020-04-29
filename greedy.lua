AN = 2000 -- size of the action space

score_address = 0x00E0;

function get_score()
    return tonumber(readbyterange(score_address, 6));
end;


function Objective()
	return get_score();
end

function readbyterange(address, length)
  local return_value = 0;
  for offset = 0,length-1 do
    return_value = return_value * 10;
    return_value = return_value + memory.readbyte(address + offset);
  end;
  return return_value;
end

R_i = {} -- right action list configuration/state
L_i = {} -- left action list configuration/state
A_i = {} -- A button action list configuration/state

-- seed for the ML loop
function SeedML()
	
	local c = {};
	c.right = false;
	
	for i=0, 50 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});
	
	for i=0, 200 do
		emu.frameadvance();
	end

	for i=0, AN/10 do

		J_i = Objective();
		emu.message(J_i);

		c.A = false;
		if math.random() < 0.1 then c.A = true; end

		if math.random() < 0.90 then 
			if math.random() < 0.50 then c.right = true; c.left = false;
			else c.right = false; c.left = true;
			end
		else c.right = false; c.left = false;
		end

		joypad.set(1, c);

		for j=0, 10 do
			R_i[j+10*i] = c.right;
			L_i[j+10*i] = c.left;
			A_i[j+10*i] = c.A;

			emu.frameadvance();
		end
	end

	emu.softreset();
end

-- ML loop
function MLLoopR()

	-- The update
	R_n = {};
	for i=0, AN do
		R_n[i] = R_i[i];
	end

	R_steps = 400;
	for Ri=0, R_steps do
		r = math.floor(AN*math.random());
		R_n[r] = not R_i[r];
	end
	-- end update

	for i=0, 100 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});

	for i=0, 50 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});
	
	for i=0, 200 do
		emu.frameadvance();
	end

	for i=0, AN do
	    emu.message(J_i);

		local c = {};
		c.right = R_n[i];
		c.left = L_i[i];
		c.A = A_i[i];

		joypad.set(1, c);
		emu.frameadvance();
	end

	J_n = Objective();
	if (J_n - J_i) > 0 then
		for i=0, AN do
			R_i[i] = R_n[i];
		end
		J_i = J_n;
	end

	io.write(J_n);
	io.write(', \n');

	emu.softreset();
end

-- ML loop
function MLLoopL()

	-- The update
	L_n = {};
	for i=0, AN do
		L_n[i] = L_i[i];
	end

	L_steps = 400;
	for Li=0, L_steps do
		r = math.floor(AN*math.random());
		L_n[r] = not L_i[r];
	end
	-- end update

	for i=0, 100 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});

	for i=0, 50 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});
	
	for i=0, 200 do
		emu.frameadvance();
	end

	for i=0, AN do
	    emu.message(J_i);

		local c = {};
		c.right = R_i[i];
		c.left = L_n[i];
		c.A = A_i[i];

		joypad.set(1, c);
		emu.frameadvance();
	end

	J_n = Objective();
	if (J_n - J_i) > 0 then
		for i=0, AN do
			L_i[i] = L_n[i];
		end
		J_i = J_n;
	end

	io.write(J_n);
	io.write(', \n');

	emu.softreset();
end


-- ML loop
function MLLoopA()

	-- The update
	A_n = {};
	for i=0, AN do
		A_n[i] = A_i[i];
	end

	A_steps = 400;
	for Ai=0, A_steps do
		r = math.floor(AN*math.random());
		A_n[r] = not A_i[r];
	end
	-- end update

	for i=0, 100 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});

	for i=0, 50 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});
	
	for i=0, 200 do
		emu.frameadvance();
	end

	for i=0, AN do
	    emu.message(J_i);

		local c = {};
		c.right = R_i[i];
		c.left = L_i[i];
		c.A = A_n[i];

		joypad.set(1, c);
		emu.frameadvance();
	end

	J_n = Objective();
	if (J_n - J_i) > 0 then
		for i=0, AN do
			A_i[i] = A_n[i];
		end
		J_i = J_n;
	end

	io.write(J_n);
	io.write(', \n');

	emu.softreset();
end

function PlayCurrent()

	for i=0, 100 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});

	for i=0, 50 do
		emu.frameadvance();
	end

	joypad.set(1, {start=1});
	emu.frameadvance();
	joypad.set(1, {start=0});
	
	for i=0, 200 do
		emu.frameadvance();
	end

	for i=0, AN do
		J_i = Objective();
	    emu.message(J_i);

		local c = {};
		c.right = R_i[i];
		c.left = L_i[i];
		c.A = A_i[i];
		joypad.set(1, c);
		emu.frameadvance();
	end
	emu.softreset();
end

-- Main function
filename = "./test.txt";
file = io.open (filename, "w");
io.output(file);

SeedML();
for i=1, 50 do

	emu.speedmode("nothrottle");
	for j=1, 5 do
		MLLoopR();
		MLLoopL();
		for i=1, 2 do
			MLLoopA();
		end
	end

	emu.speedmode("normal");
	PlayCurrent();
end

io.close(file);