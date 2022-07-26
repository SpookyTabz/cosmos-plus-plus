short *videoMemory = ((short *)0xb8000);

void clearScreen()
{
    // clear the screen (80 columns, 25 rows represented consecutively)
    for (auto i = 0; i < (80 * 25); i++)
    {
        videoMemory[i] = 0 | ' ';
    }
}

extern "C" void kernel_main()
{
    clearScreen();

    auto message = "Hello! this OS was made with cosmos++!";
    auto color = 0x08;

    for (auto i = 0; message[i] != '\0'; ++i)
    {
        if (message[i] == ' ')
        {
            // switch color at wordbreak
            color = (color + 1) % 0x0F;
        }

        // first byte is color, second is the text
        videoMemory[i] = color << 8 | message[i];
    }

    while (1);
}