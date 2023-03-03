def get_variables(*args):
    return {'PYTHONPATH_VAR_%d' % len(args): 'Varfile found from PYTHONPATH',
            'PYTHONPATH_ARGS_%d' % len(args): '-'.join(args)}
