-- [[ Градиент между двумя цветами в зависимости от % ]] --
function Dec2Hex(nValue) -- http://www.indigorose.com/forums/threads/10192-Convert-Hexadecimal-to-Decimal
  if type(nValue) == "string" then
      nValue = String.ToNumber(nValue);
  end
  print(nValue)
  nHexVal = string.format("%X", math.floor(nValue)); -- %X returns uppercase hex, %x gives lowercase letters
  sHexVal = nHexVal .. "";
  if nValue < 16 then
      return "0" .. tostring(sHexVal)
  else
      return sHexVal
  end
end

function RGBToHSV(red, green, blue)
  -- Returns the HSV equivalent of the given RGB-defined color
  -- (adapted from some code found around the web)

  local hue, saturation, value;

  local min_value = math.min(red, green, blue);
  local max_value = math.max(red, green, blue);

  value = max_value;

  local value_delta = max_value - min_value;

  -- If the color is not black
  if max_value ~= 0 then
      saturation = value_delta / max_value;

      -- If the color is purely black
  else
      saturation = 0;
      hue = -1;
      return hue, saturation, value;
  end

  if red == max_value then
      hue = (green - blue) / value_delta;
  elseif green == max_value then
      hue = 2 + (blue - red) / value_delta;
  else
      hue = 4 + (red - green) / value_delta;
  end

  hue = hue * 60;
  if hue < 0 then
      hue = hue + 360;
  end

  return hue, saturation, value;
end
function HSVToRGB(hue, saturation, value)
  -- Returns the RGB equivalent of the given HSV-defined color
  -- (adapted from some code found around the web)

  -- If it's achromatic, just return the value
  if saturation == 0 then
      return value, value, value;
  end

  -- Get the hue sector
  local hue_sector = math.floor(hue / 60);
  local hue_sector_offset = (hue / 60) - hue_sector;

  local p = value * (1 - saturation);
  local q = value * (1 - saturation * hue_sector_offset);
  local t = value * (1 - saturation * (1 - hue_sector_offset));

  if hue_sector == 0 then
      return value, t, p;
  elseif hue_sector == 1 then
      return q, value, p;
  elseif hue_sector == 2 then
      return p, value, t;
  elseif hue_sector == 3 then
      return p, q, value;
  elseif hue_sector == 4 then
      return t, p, value;
  elseif hue_sector == 5 then
      return value, p, q;
  end
end
function fade_RGB(colour1, colour2, percentage)
  r1, g1, b1 = string.match(colour1, "#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
  r2, g2, b2 = string.match(colour2, "#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
  r3 = math.abs(tonumber(r1, 16) - tonumber(r2, 16))
  g3 = math.abs(tonumber(g1, 16) - tonumber(g2, 16))
  b3 = math.abs(tonumber(b1, 16) - tonumber(b2, 16))

  hue, sat, val = RGBToHSV(r3, g3, b3)
  red, green, blue = HSVToRGB(percentage, sat, val)

  return "#" .. Dec2Hex(red) .. Dec2Hex(green) .. Dec2Hex(blue)
end