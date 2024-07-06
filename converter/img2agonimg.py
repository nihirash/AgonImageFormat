#!python3

from PIL import Image
from sys import argv

def convert_bitmap(source_image):
    pixel_data = list(source_image.getdata())
    
    rgb2222_data = bytearray()
    for pixel in pixel_data:
        r, g, b, a = pixel
        pixel_value = ((r >> 6) & 0x03 | (((g >> 6) & 0x03) << 2) | (((b >> 6) & 0x03) << 4) | (((a >> 6) & 0x03) << 6))
        rgb2222_data.append(pixel_value)

    return rgb2222_data

def pack_bitmap(bitmap):
    max_frame_size = 255
    frame_size = 0
    byte = -444

    data = bytearray()

    for read_byte in bitmap:
        if frame_size == 0:
            frame_size = 1
        else:
            if frame_size == max_frame_size or byte != read_byte:
                data.append(frame_size)
                data.append(byte)
                frame_size = 1
            else:
                frame_size = frame_size + 1
        byte = read_byte
    data.append(frame_size)
    data.append(byte)

    return data


def read_image_from_file(filename):
    image = Image.open(filename)
    image = image.convert('RGBA')
    image = image.point(lambda p: p // 85 * 85)
    
    return image

def convert_image(filename):
    image = read_image_from_file(filename)

    width, height = image.size

    bitmap = convert_bitmap(image)
    rle_ed_image = pack_bitmap(bitmap)

    datum = bytearray()

    datum.extend(b'IM')

    datum.extend(len(bitmap).to_bytes(2, 'little'))
    
    datum.extend(width.to_bytes(2, 'little'))
    datum.extend(height.to_bytes(2, 'little'))
   
    if len(bitmap) < len(rle_ed_image):
        datum.append(0)
        datum.extend(bitmap)
    else:
        datum.append(1)

        datum.extend((len(rle_ed_image) // 2).to_bytes(2, 'little'))
        datum.extend(rle_ed_image)

    return datum

if __name__ == "__main__":
    print("Image to Agon's Buffered Image converter")
    app_name=argv[0]
    if len(argv) != 3:
        print("Usage: " + app_name + " <input-image> <output-file>")
    else:
        with open(argv[2], "wb") as f:
            f.write(convert_image(argv[1]))