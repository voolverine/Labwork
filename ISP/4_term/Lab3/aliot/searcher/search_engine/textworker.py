def split_text_in_words(text):
    split_by = [',', '.', '\\', '/', '\n', '\t', ':', '!', '?', ';', '-', ' ', \
                    '}', '{', '\r', '\'', '\"', '(', ')', '#', '$', '%', '^', '&', '*', \
                    '>', '<'] 

    # to append last word, add fake point to the end
    text = ''.join([text, '.']) 

    words = []
    buffer = []

    for character in text:
        if character in split_by:
            if len(buffer) > 0:
                words.append(''.join(buffer))
            buffer = []
        else:
            buffer.append(character)

    return words


def get_urls_from_text(text):
    split_by = [' ', '\n', '\t', '\r', '\a'] 
    text += ' '
    
    urls = []
    buffer = []
    print len(buffer)
    for character in text:
        if character in split_by:
            if len(buffer) > 0:
                urls.append(''.join(buffer))
            buffer = []
        else:
            buffer.append(character)

    return urls



def main():
    pass

if __name__ == '__main__':
    main()
