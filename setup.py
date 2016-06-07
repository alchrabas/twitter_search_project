from distutils.core import setup

setup(
    name='twitter_search',
    version='1.0',
    url='https://github.com/alchrabas/twitter_search_project',
    license='BSD',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.4',
    ],
    author='Aleksander Chrabaszcz & Jacek Fleszar',
    author_email='',
    install_requires=['nltk', 'tweepy', 'requests', 'psycopg2'],
    description=''
)
