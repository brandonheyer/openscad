function toInt(str) = 
  let(d = [for (s = str) ord(s) - 48], l = len(d) - 1)
    [
      for (
        i = 0, a = d[i];
        i <= l; 
        i = i + 1, a = 10 * a + (d[i] ? d[i] : 0)
      ) a
    ][l];

function getSeed() = 
  let (chars = rands(0, 24, 3))
    let (nums = rands(1, 9, 2))
      let (seed =
        str(
          floor(nums[0]),
          floor(nums[1]),
          chr(chars[0] + 65),
          chr(chars[1] + 65)
        )
       ) [seed, getSeedNumber(seed)];
         
    
function getSeedNumber(v) =
    let(charA = floor((ord(v[2]) - 65) / 10), charB = floor((ord(v[3]) - 65) / 10))
      toInt(
        str(
          toInt(v[0]),
          toInt(v[1]),
          charA,
          (ord(v[2]) - 65) % 10,
          charB,
          (ord(v[3]) - 65) % 10
        )
      );
      
 function getSeedStr(v) =
  let(strV = str(v))
    str(
      strV[0],
      strV[1],
      chr((toInt(strV[2]) * 10) + (toInt(strV[3]) + 65)),
      chr((toInt(strV[4]) * 10) + (toInt(strV[5]) + 65))
    ); 
