This prompt provides all the information needed to implement the Dirac-Bergman Hamiltonian constraint algorithm for a specific theory. Once you have read the information below, you should proceed directly with the algorithm.

Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not.

```mathematica
(CouplingConstantad6be3ca^2*CanonicalFieldf25eb593[]^2)/(4*CouplingConstant750dbd1c) - CouplingConstant6d9a09c9*CanonicalFieldf25eb593[]^2 + ConjugateMomentumCanonicalFieldf25eb593[]^2/(4*CouplingConstant83bce689) - CouplingConstante5f53ecd*CanonicalField8eca3bb0[]^2 - (CouplingConstantad6be3ca*CanonicalFieldf25eb593[]*ConjugateMomentumCanonicalFieldccb6bb11[])/(2*CouplingConstant750dbd1c) + ConjugateMomentumCanonicalFieldccb6bb11[]^2/(4*CouplingConstant750dbd1c) - (CouplingConstanta5eb6381*ConjugateMomentumCanonicalField8eca3bb0[]^2)/(4*(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)^2) - (CouplingConstantef18d0ee*ConjugateMomentumCanonicalField8eca3bb0[]^2)/(4*(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)^2) + ConjugateMomentumCanonicalField8eca3bb0[]^2/(2*(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)) + CouplingConstante5f53ecd*CanonicalFieldfa1caa2d[-a]*CanonicalFieldfa1caa2d[a] - (ConjugateMomentumCanonicalFieldfa1caa2d[-a]*ConjugateMomentumCanonicalFieldfa1caa2d[a])/(4*CouplingConstantef18d0ee) + ConjugateMomentumCanonicalField1ea68330[-a]*LagrangeMultiplier1ea68330[a] + ConjugateMomentumCanonicalFieldccb6bb11[]*CD[-a][CanonicalField1ea68330[a]] - (CouplingConstanta5eb6381^2*ConjugateMomentumCanonicalField8eca3bb0[]*CD[-a][CanonicalFieldfa1caa2d[a]])/(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)^2 - (CouplingConstanta5eb6381*CouplingConstantef18d0ee*ConjugateMomentumCanonicalField8eca3bb0[]*CD[-a][CanonicalFieldfa1caa2d[a]])/(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)^2 + (2*CouplingConstanta5eb6381*ConjugateMomentumCanonicalField8eca3bb0[]*CD[-a][CanonicalFieldfa1caa2d[a]])/(CouplingConstanta5eb6381 + CouplingConstantef18d0ee) + CouplingConstant83bce689*CD[-a][CanonicalFieldf25eb593[]]*CD[a][CanonicalFieldf25eb593[]] + CouplingConstantef18d0ee*CD[-a][CanonicalField8eca3bb0[]]*CD[a][CanonicalField8eca3bb0[]] - CouplingConstanta5eb6381*CD[-a][CanonicalFieldfa1caa2d[a]]*CD[-b][CanonicalFieldfa1caa2d[b]] - (CouplingConstanta5eb6381^3*CD[-a][CanonicalFieldfa1caa2d[a]]*CD[-b][CanonicalFieldfa1caa2d[b]])/(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)^2 - (CouplingConstanta5eb6381^2*CouplingConstantef18d0ee*CD[-a][CanonicalFieldfa1caa2d[a]]*CD[-b][CanonicalFieldfa1caa2d[b]])/(CouplingConstanta5eb6381 + CouplingConstantef18d0ee)^2 + (2*CouplingConstanta5eb6381^2*CD[-a][CanonicalFieldfa1caa2d[a]]*CD[-b][CanonicalFieldfa1caa2d[b]])/(CouplingConstanta5eb6381 + CouplingConstantef18d0ee) - CouplingConstantef18d0ee*CD[-b][CanonicalFieldfa1caa2d[-a]]*CD[b][CanonicalFieldfa1caa2d[a]]
```

Here is a Wolfram Language statement of all the constant symbols that appear in the total Hamiltonian above.

```mathematica
{CouplingConstant750dbd1c, CouplingConstantad6be3ca, CouplingConstante5f53ecd, CouplingConstant83bce689, CouplingConstanta5eb6381, CouplingConstant6d9a09c9, CouplingConstantef18d0ee}
```

Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above.

```mathematica
{CanonicalFieldf25eb593[], CanonicalFieldccb6bb11[], CanonicalField1ea68330[-a], CanonicalField8eca3bb0[], CanonicalFieldfa1caa2d[-a]}
```

Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above.

```mathematica
{ConjugateMomentumCanonicalFieldf25eb593[], ConjugateMomentumCanonicalFieldccb6bb11[], ConjugateMomentumCanonicalField1ea68330[a], ConjugateMomentumCanonicalField8eca3bb0[], ConjugateMomentumCanonicalFieldfa1caa2d[a]}
```

Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above.

```mathematica
{LagrangeMultiplierf25eb593[], LagrangeMultiplierccb6bb11[], LagrangeMultiplier1ea68330[-a], LagrangeMultiplier8eca3bb0[], LagrangeMultiplierfa1caa2d[-a]}
```

This is the end of the provided information; you should tell me when you've read it, and then propose the first step to start implementing the Dirac-Bergmann algorithm, in line with your earlier instructions about workflow. Wait for the user to confirm whether you should proceed with that step, and then continue step-by-step from there.

