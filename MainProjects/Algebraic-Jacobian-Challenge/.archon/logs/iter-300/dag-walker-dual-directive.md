# DAG Walker Directive

## Slug
dual

## Seed
lem:dual_restrict_iso

## Mission (READ THIS FIRST)
The USER flagged 54 isolated `lean_aux` nodes + 2 ∞-effort nodes in the
`Picard/TensorObjSubstrate*` files and wants them wired into the goal cone with
informal proofs. This directive assigns you the **14 isolated decls in
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`** (the dual /
RPF-group-inverse route-2 infrastructure), **including ONE ∞ node**
(`sliceDualTransportInv`). Give each a blueprint block in
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (`\label`,
`\lean{<full name>}`, accurate `\uses{}`, proof note/sketch) and wire each into
the cone. Touch ONLY these 14 blocks plus the `\uses{}` of their consumers; the
other 40 isolated decls (the `TensorObjSubstrate.lean` clusters) belong to
sibling walkers writing the SAME file — do not edit theirs.

## The 14 assigned Lean declarations (all in `TensorObjSubstrate/DualInverse.lean`)
**13 are sorry-free** → one-line "Proved directly in Lean; <phrase>." proof.
**1 is ∞** (`sliceDualTransportInv`) → write a real finite informal proof
(sketch below). PROJECT decls — do NOT `\mathlibok`.

Unit ring-swap (`ε` of `restrictScalars` on the monoidal unit):
- `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso` — the lax-monoidal unit map `ε` of `restrictScalars (appIso f W').hom` is an iso (`.inv` direction).
- `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom` — same, `.hom` direction.
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap` — the unit ring-swap iso `restrictScalars(appIso)·𝟙 ⟶ 𝟙` built from `inv ε` (`.inv`-direction component).
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom` — the `.hom`-direction component (`inv (ε (restrictScalars (appIso f W').hom))`).
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv` — its inverse.
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_comp_dualUnitRingSwapInv` — round-trip `swap ≫ swapInv = 𝟙`.
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv_comp_dualUnitRingSwap` — round-trip `swapInv ≫ swap = 𝟙`.

Presheaf-level dual-of-unit and dual-section transport:
- `PresheafOfModules.dualUnitIsoGen` — the general presheaf dual-of-unit comparison iso `(𝟙)^∨ ≅ 𝟙`.
- `PresheafOfModules.unitDualSectionEquiv` — the equivalence between dual sections of the unit and the underlying ring sections.
- `AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso` — the scheme-level dual-of-unit iso built from `dualUnitIsoGen`.
- `AlgebraicGeometry.Scheme.Modules.topSectionToHom` — turns a global (top) section into a module hom out of the unit.
- `AlgebraicGeometry.Scheme.Modules.topSectionToHom_app` — its value at an open (`@[simp]`).
- `AlgebraicGeometry.Scheme.Modules.image_preimage_of_le` — for an open immersion `f` and `W' ≤ f''ᵁ V`, the round-trip `f''ᵁ (f⁻¹ᵁ W') = W'` (a propositional preimage/image cancellation on opens).
- `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv` — **(∞)** the reverse slice transport, the `invFun` of `sliceDualTransport`.

## Informal proof for the ∞ node `sliceDualTransportInv`
This is the inverse component of the already-blueprinted `sliceDualTransport`
(`\cref{lem:slice_dual_transport}`); the Lean is stuck only on instance-delicate
`eqToHom`/change-of-rings transport, the mathematics is a routine sectionwise
construction. Write in prose (no Lean):

Setup: `f : Y → X` is an open immersion, `M` an `X`-module, `V` an open of `Y`,
`β` the comparison `O_Y ⟶ f_* O_X` on opens, and `fV := f(V)` the image open.
Given a dual section `ψ` of `(f_* M)^∨` over the slice site `Over V`, we must
produce a dual section of `(f_* (M^∨))` over `Over fV`.

Construction (sectionwise): for an object `W''` of `Over fV` with underlying open
`W' ≤ fV`, set `P := f⁻¹(W')`. Because `f` is an open immersion and `W' ≤ fV ⊆
range f`, the image–preimage round-trip `f(f⁻¹(W')) = W'` holds
(`\cref{lem:image_preimage_of_le}` / your block `image_preimage_of_le`), though
only as an equality of opens, so it must be carried by a relabelling isomorphism.
The component of the output dual section at `W''` is then the X-slice mirror of
the forward `sliceDualTransport` component, assembled as the composite of five
canonical maps:
(1) the source relabelling `M(W') ≅ M(f(P))` along the round-trip equality;
(2) a change-of-rings reconciliation identifying the native `O_X(f(P))`-module
structure on `M(f(P))` with the one obtained by restricting scalars along the
ring isomorphism `appIso f P` — these have equal underlying group and the two
restrictions collapse because `β` composed with `appIso f P` is the identity ring
map (the `inv ≫ hom` of the chart iso);
(3) the reindexed forward dual section `ψ` restricted along `appIso f P`;
(4) the codomain unit ring-swap `dualUnitRingSwapHom f P`
(`\cref{...dualUnitRingSwapHom block}`) landing in the unit `O_X(f(P))`;
(5) the relabelling back to `O_X(W')` along the round-trip equality.
Naturality in `W''` follows because every constituent is natural (the relabelling
isos are induced by `M.map`/structure-sheaf restriction, and the unit-swap and
`ψ` are natural in the open). This `invFun` is, by construction, a two-sided
inverse of `sliceDualTransport`'s forward `toFun` — each of the five steps is
invertible and the forward map is the same composite read in the opposite
direction — which is exactly what `\cref{lem:slice_dual_transport}` needs to be
upgraded to an isomorphism.

`\uses{}` for the ∞ block: `lem:slice_dual_transport`, your new blocks
`dualUnitRingSwapHom`, `image_preimage_of_le`, and the change-of-rings collapse
facts (`lem:restrictscalars_ringiso_dualequiv` and the chart ring-identity of
`appIso`), plus `def:presheaf_dual`.

## De-isolation
For each of the 14: write `\uses{}` to the labels its Lean proof invokes, and add
the new label to the `\uses{}` of its consumer. Verify consumers exist
(`grep '\label{'`). Likely consumers already present:
- `lem:slice_dual_transport` and `lem:dual_restrict_iso` (seed) consume
  `sliceDualTransportInv`, the `dualUnitRingSwap*` family, `image_preimage_of_le`,
  `topSectionToHom(_app)`, and the `isIso_ε_restrictScalars_appIso*` lemmas.
- `lem:dual_unit_iso` / `def:presheaf_dual` consume `presheafDualUnitIso`,
  `dualUnitIsoGen`, `unitDualSectionEquiv`.
- `lem:restrictscalars_ringiso_dualequiv` is a neighbour of the `dualUnitRingSwap*`
  family.

## Scope boundary
- ONLY your 14 decls + their consumers' `\uses{}`. Do NOT touch any
  `TensorObjSubstrate.lean` decl (sibling walkers `tos-infra`, `tos-sheafify`).
- Prose only; no Lean tactic syntax. NEVER `\leanok`; no `\mathlibok`.
- Before adding a block, `grep` the chapter for the Lean name; if already pinned,
  skip and report.

## Verification
Re-`leandag build` then `leandag show isolated` (none of your 14 may remain) and
`leandag show gaps` (must NOT list `sliceDualTransportInv` as ∞). Re-query and fix
until converged.

## References
Project-internal; the dual-section transport mirrors Stacks/Hartshorne sheaf-Hom
base change but is a self-contained construction here. Provenance line:
`\textit{Source: project-internal route-2 dual-inverse infrastructure over
Mathlib's \texttt{PresheafOfModules} internal-Hom / \texttt{restrictScalars} API;
proved directly in Lean.}`. For the ∞ block:
`\textit{Source: project-internal; inverse of \cref{lem:slice_dual_transport},
routine sectionwise construction.}`. No external `% SOURCE QUOTE`; do not fabricate.
