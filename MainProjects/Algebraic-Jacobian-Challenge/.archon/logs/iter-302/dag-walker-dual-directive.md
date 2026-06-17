# DAG Walker Directive

## Slug
dual

## Seed
lem:slice_dual_transport
(`AlgebraicGeometry.Scheme.Modules.sliceDualTransport`, ~L6157 of
`Picard_TensorObjSubstrate.tex`; its cone is the dual-route helpers in
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`.)

## Mission (the USER's explicit directive this iteration)
Connect the **14 isolated lean-aux helpers** of `DualInverse.lean` into the graph.
Most are ALREADY described in prose inside the proof body of `lem:slice_dual_transport`
(~L6187–6330) with an **inline** `\lean{}` — which leandag does NOT count as
coverage. Give each its own `\label`'d block (lifting the existing prose into the
statement/proof) and **wire `lem:slice_dual_transport` (and `lem:dual_restrict_iso`
at ~L6338) to `\uses{}` each new label.** End-state: none of the 14 is isolated.

leandag pins a declaration to the FIRST `\lean{}` of a `\label`'d block only.

## Targets — create a blueprint block for EACH (all in `DualInverse.lean`)
For each: `\begin{lemma}`/`\begin{definition}` + `\label{...}` +
`\lean{AlgebraicGeometry.Scheme.Modules.<name>}` + accurate `\uses{}` from the Lean
body + a `\begin{proof}` note. Sorry-free ones get a one-line "Proved directly in
Lean — <shape>." note; the ONE `sorry`-bodied node gets a genuine informal proof.

Sorry-free:
- `dualUnitRingSwap` — `inv(ε(restrictScalars g))`, `g = (f.appIso W).inv.hom` at the
  `CommRingCat` level: the unit codomain ring-iso swap (leg B), inv-direction.
- `dualUnitRingSwapHom` — the same swap in the `hom`-direction,
  `inv(ε(restrictScalars (f.appIso W'').hom))`, used by the inverse leg.
- `dualUnitRingSwapInv` — the `inv`-direction partner used to assemble the cancel pair.
- `dualUnitRingSwap_comp_dualUnitRingSwapInv` and
  `dualUnitRingSwapInv_comp_dualUnitRingSwap` — the round-trip cancellation identities
  of the swap pair (`Iso.inv_hom_id` / `Iso.hom_inv_id` of `f.appIso`).
- `isIso_ε_restrictScalars_appIso` and `isIso_ε_restrictScalars_appIso_hom` — the
  lax-monoidal unit `ε` of `restrictScalars` along the structure-ring iso is invertible
  (both the inv- and hom-direction), because the ring map is an isomorphism.
- `image_preimage_of_le` — the open-immersion down-set identity
  `ι_!(ι^{-1} W'') = W''` for an open `W'' ≤ fV` contained in `range f`; the fact the
  inverse reindexing relies on.
- `presheafDualUnitIso` / `dualUnitIsoGen` — the dual-of-unit isomorphism for the unit
  section at the presheaf level (the unit-handling identification).
- `topSectionToHom` and `topSectionToHom_app` — the global-section-to-hom map of an
  internal-hom value and its section-level (`app`) formula.
- `unitDualSectionEquiv` — the equivalence identifying dual sections of the unit with
  the underlying hom/sections (the unit-side packaging).

**∞ node — write a real informal proof (one of the 2 the user wants proven):**
- `sliceDualTransportInv` (`sorry`-bodied). This is the **inverse leg** of
  `sliceDualTransport`, currently described in the "Inverse." paragraph of
  `lem:slice_dual_transport`'s proof (~L6225–6252). The math already exists there:
  the inverse `PresheafOfModules.Hom` mirrors the forward component formula with two
  changes — it uses `(f.appIso W'').hom` in place of its inverse, and its
  `ε`-codomain swap is `dualUnitRingSwapHom` (the inverse of `ε` in the hom-direction),
  reindexed by the inverse of the down-set bijection `W'' ↔ f^{-1}W''` supplied by
  `image_preimage_of_le`; additivity/`O_Y(V)`-linearity follow as in the forward leg
  (steps (i)–(iii)); naturality reduces to the `ε`-naturality of `restrictScalars`.
  Lift this into a self-contained `\begin{proof}` for the new
  `\lean{...sliceDualTransportInv}` block and `\uses{}`
  `dualUnitRingSwapHom`, `image_preimage_of_le`, `isIso_ε_restrictScalars_appIso_hom`,
  `lem:restrictscalars_ringiso_dualequiv`, and `presheafDualUnitIso`/`dualUnitIsoGen`.
  Provenance: `\textit{Source: internal categorical construction; no external reference.}`.

## Wiring — add `\uses{}` edges into existing consumers
Add each new label to the `\uses{}` of `lem:slice_dual_transport` and, where the Lean
shows the dependency, `lem:dual_restrict_iso`. Also have `lem:slice_dual_transport`
`\uses{}` the new `sliceDualTransportInv` block (the forward equivalence packages the
inverse leg). End-state: every new block lies on a `\uses{}` path into the chapter
goal `lem:tensorobj_inverse_invertible` via the dual lemmas.

## Depth / scope
One cluster, one file. Do NOT touch the `TensorObjSubstrate.lean` clusters (done by
sibling walkers) or any protected chapter. All edits inside
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.

## References
The existing `lem:slice_dual_transport` / `lem:dual_restrict_iso` blocks already carry
the Stacks `references/stacks-modules.tex` citation (pullback of internal Hom). Reuse
that citation for any block that restates the dual-of-pullback fact; the swap/cancel/
down-set helpers are internal constructions needing no external source.
