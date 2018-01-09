FROM ruby:2.3.2

ENV LANG C.UTF-8
ENV LANGUAGE C:en
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install apt-transport-https
RUN apt-key adv --keyserver 83.149.68.11 --recv-keys 09617FD37CC06B54 && echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb

RUN apt-get update && apt-get install -y \
  crystal\
  elixir\
  golang\
  luajit luarocks\
  nodejs\
  imagemagick libmagickwand-dev\
  bc\
  ghostscript

RUN luarocks install process --from=http://mah0x211.github.io/rocks/
RUN gem install gruff pry

ENV APP_HOME /file-bench
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD . $APP_HOME

ENTRYPOINT "./sh-scripts/execute-all-and-generate-reports.sh"
