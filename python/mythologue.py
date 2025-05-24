import sys
import nltk
from nltk.tokenize import sent_tokenize
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.corpus import wordnet



def main():


    args = sys.argv
    string_tokens_1 = process_text(args[1])
    string_tokens_2 = process_text(args[2])

    similarities = []
    for synset1 in string_tokens_1:
        best_similarity_score = 0
        for synset2 in string_tokens_2:
            if synset1 and synset2:
                similarity = wordnet.wup_similarity(synset1[0], synset2[0])
                best_similarity_score = max(best_similarity_score, similarity)
                #print(synset1[0], synset2[0], similarity)
        similarities.append(best_similarity_score)
    
    #print(similarities)
    print(sum(similarities) / len(similarities))


def dice_sorenson_coeff(sample1: list, sample2: list) -> float:
    common_elements: int = 0
    for x in sample1:
        if x in sample2:
            common_elements += 1
    return (2 * common_elements) / (len(sample1) + len(sample2))


    
def process_text(text) -> list:
    tokenized = word_tokenize(text)

    stop_words = set(stopwords.words("english"))
    tokenized = [word for word in tokenized if word.casefold() not in stop_words]

    lemmatizer = WordNetLemmatizer()
    lemmatized = [lemmatizer.lemmatize(word) for word in tokenized]
    
    return [wordnet.synsets(word) for word in tokenized]
    


if __name__ == "__main__":
    main()