import nltk
from nltk import FreqDist
from nltk.collocations import*

for num in range(1,8): 
    print('HP'+str(num)+'.txt')
    filename = 'HP'+str(num)+'.txt'
    myText = open(filename)
    myTexttext = myText.read()
    hp1 = myTexttext
    len(hp1)
    hp1tokens = nltk.word_tokenize(hp1)
    len(hp1tokens)
    hp1words = [word.lower() for word in hp1tokens if word.isalpha()]
    nltkstopwords = nltk.corpus.stopwords.words('english')
    morestopwords = ["'re", "'ve", "'ll", "'d", "'s", "'t", ".", ",", "'", "''", "``", "?", "!", "...", ";", "'m", "--"]
    evenmorestopwords = ["chapter", "'s","\"", "1"]
    stopwords = nltkstopwords + morestopwords + evenmorestopwords
    stoppedhp1words = [w for w in hp1words if not w in stopwords]
    hp1fdist = FreqDist(stoppedhp1words)
    hp1fdistkeys = list(hp1fdist.keys())
    hp1fdistkeys[:50]
    hp1topkeys = hp1fdist.most_common(150)
    print('FREQUENCY')
    for pair in hp1topkeys: 
        print(pair)
    numwords = len(stoppedhp1words)
    hp1topkeysnormalized = [(word, freq/numwords) for (word, freq) in hp1topkeys]
    for pair in hp1topkeysnormalized: 
        print(pair)
    hp1bigrams = list(nltk.bigrams(stoppedhp1words))
    hp1trigrams = list(nltk.trigrams(stoppedhp1words))
    # hp1bigrams = list(nltk.bigrams(hp1words))
    print('BIGRAMS')
    for bigram in hp1bigrams[:50]:
        print(bigram)
    print('BIGRAM FREQUENCY')
    bigramFreq = FreqDist(hp1bigrams)
    for bigram in bigramFreq.most_common(50):
        print(bigram)
    print('TRIGRAMS')
    for trigram in hp1trigrams[:50]:
        print(trigram)
    print('TRIGRAM FREQUENCY')
    trigramFreq = FreqDist(hp1trigrams)
    for trigram in trigramFreq.most_common(50):
        print(trigram)
    bigram_measures = nltk.collocations.BigramAssocMeasures()
    finder = BigramCollocationFinder.from_words(hp1words)
    finder.apply_word_filter(lambda w: w in stopwords)
    scored = finder.score_ngrams(bigram_measures.raw_freq)
    for bscore in scored[:50]:
        print(bscore)
    scored = finder.score_ngrams(bigram_measures.raw_freq)
    for bscore in scored[:50]:
        print(bscore)
    scored = finder.score_ngrams(bigram_measures.pmi)
    print('PMI')
    for bscore in scored[:50]:
        print(bscore)
    finder3 = BigramCollocationFinder.from_words(hp1words)
    finder3.apply_freq_filter(5)
    scored = finder3.score_ngrams(bigram_measures.pmi)
    for bscore in scored[:50]:
        print(bscore)
