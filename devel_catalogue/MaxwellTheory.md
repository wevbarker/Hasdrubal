Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not.

```mathematica
ConjugateMomentumVectorFieldRank10p[]*VectorFieldRank10pLagrangeMultiplier[] + (ConjugateMomentumVectorFieldRank11m[-a]*ConjugateMomentumVectorFieldRank11m[a])/(2*FirstKineticCoupling) + ConjugateMomentumVectorFieldRank11m[a]*CD[-a][VectorFieldRank10p[]] - (FirstKineticCoupling*CD[-a][VectorFieldRank11m[-b]]*CD[b][VectorFieldRank11m[a]])/2 + (FirstKineticCoupling*CD[-b][VectorFieldRank11m[-a]]*CD[b][VectorFieldRank11m[a]])/2
```

Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above.

```mathematica
{VectorFieldRank10p[], VectorFieldRank11m[-a]}
```

Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above.

```mathematica
{ConjugateMomentumVectorFieldRank10p[], ConjugateMomentumVectorFieldRank11m[a]}
```

Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above.

```mathematica
{VectorFieldRank10pLagrangeMultiplier[], VectorFieldRank11mLagrangeMultiplier[-a]}
```

