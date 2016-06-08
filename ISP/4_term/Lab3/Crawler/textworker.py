def split_text_in_words(text):
    split_by = [',', '.', '\\', '/', '\n', '\t', ':', '!', '?', ';', '-', ' ', \
                    '}', '{', '\r', '\'', '\"', '(', ')', '#', '$', '%', '^', '&', '*', \
                    '>', '<'] 

    # to append last word, add fake point to the end
    ''.join([text, '.']) 

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

def main():
    pass

if __name__ == '__main__':
    main()
