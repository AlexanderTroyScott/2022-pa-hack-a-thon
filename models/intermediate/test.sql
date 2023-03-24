{% set binary_data = 
    macro('binarize_columns',
          table='int_2023_data',
          column='hashtag',
          prefix='hashtag_') 
%}
