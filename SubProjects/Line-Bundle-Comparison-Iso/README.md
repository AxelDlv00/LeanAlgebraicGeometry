# AlgebraicJacobian — Line-Bundle Comparison Iso

<!-- archon:readme -->

## Project

A Lean 4 + Mathlib subproject **extracted** from the
Algebraic-Jacobian-Challenge (Christian Merten's Jacobian challenge). It
isolates the **comparison-isomorphism substrate on line bundles** that supplies
the relative Picard sheaf `Pic♯_{C/k}` with its abelian-group structure — the
A.1.c.sub work package of the parent.

Concretely, the goal is to build, on the `tensorObj`/dual machinery for
`X.Modules`, the two loc-triv comparison isomorphisms and their consumer:

- **`lem:pullback_tensor_iso_loctriv`** — `pullbackTensorIsoOfLocallyTrivial`:
  pullback commutes with `⊗` on locally trivial modules (the D3′ route).
- **`lem:dual_isLocallyTrivial`** — `dual_isLocallyTrivial`: the dual of a
  locally trivial module is locally trivial (the DUAL route).
- **`thm:rel_pic_addcommgroup_via_tensorobj`** —
  `PicSharp.addCommGroup_via_tensorObj`: assembles these into the
  `AddCommGroup` structure on the relative Picard sheaf.

These three seed nodes and their dependency cone (108 blueprint nodes) are the
entire scope. Six declarations remain to be proved (`sorry`): `dual_restrict_iso`,
`pullbackTensorMap_restrict`, `sheafificationCompPullback_comp_tail`,
`sliceDualTransport`, `sliceDualTransportInv`, `exists_tensorObj_inverse`.

Module names, file paths, and blueprint `\label{}`/`\lean{}` names are kept
identical to the parent so proved results merge back as a clean three-way merge.

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `AlgebraicJacobian/Picard/LineBundlePullback.lean` — line bundles on a relative curve, `IsLocallyTrivial`, pullback along the projection
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (+ `TensorObjSubstrate/{StalkTensor,PresheafInternalHom,DualInverse,Vestigial}.lean`) — the `Scheme.Modules.tensorObj` / dual machinery and the comparison isos
- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — the relative Picard sheaf and its `AddCommGroup` structure
- `blueprint/` — leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `references/` — sources backing the formalization
- `archon-protected.yaml` — declarations agents must not modify (the seed targets)
- `.archon/` — agent state (not committed)

## How to build

```bash
lake exe cache get   # download Mathlib olean cache
lake build           # compile the project
```

## How to run the formalization loop

```bash
archon loop .
```

This launches the plan → prove → review loop and opens a dashboard.
