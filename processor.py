import trimesh
import time 
import argparse

# add path argument
parser = argparse.ArgumentParser()
parser.add_argument('-p', '--path', type=str)

args = parser.parse_args()
path = args.path

start = time.time()
# Load your mesh
mesh = trimesh.load_mesh(path)

# Get the IDs of the connected components
components = mesh.split(only_watertight=False)


# The largest connected component can be found as follows:
largest_component = max(components, key=lambda component: len(component.faces))

# The largest_component now contains only the largest connected component of the mesh
largest_component.export('res.ply')
end = time.time()
print("Total time is", end - start)
