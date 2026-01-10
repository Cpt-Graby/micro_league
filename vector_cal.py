
import sys
import math

def main():

    # Lecture des points
    x1, y1, z1 = 0.0, 5.0, 0.0
    x2, y2, z2 = map(float, sys.argv[1:])

    # Calcul du vecteur AB
    vx = x2 - x1
    vy = y2 - y1
    vz = z2 - z1

    vecteur = (vx, vy, vz)

    # Norme du vecteur
    norme = math.sqrt(vx**2 + vy**2 + vz**2)

    print(f"Vecteur résultant : {vecteur}")
    print(f"Norme du vecteur : {norme}")

    if norme == 0:
        print("Impossible de normaliser un vecteur nul.")
    else:
        vecteur_normalise = (vx / norme, vy / norme, vz / norme)
        print(f"Vecteur normalisé : {vecteur_normalise}")

if __name__ == "__main__":
    main()

