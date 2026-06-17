# DAG Walker Report

## Slug
dual

## Seed
lem:slice_dual_transport (`AlgebraicGeometry.Scheme.Modules.sliceDualTransport`)

## Status
COMPLETE — all 14 isolated `DualInverse.lean` helpers are now matched, blueprinted, and
statement-traversable into the dual lemmas. One residual edge into the *chapter goal* is
out of scope (TensorObjSubstrate goal block; see Notes).

## Cone before → after
- ∞ holes: project-wide gaps **0 → 0** (the one `sorry`-bodied node `sliceDualTransportInv`
  was given a genuine informal proof, so it is **finite-effort** — not ∞ — even though its
  Lean still carries a `sorry`).
- broken `\uses` (`leandag` `unknown_uses`): **0 → 0**.
- unmatched lean-aux nodes (the 14 targets): **14 → 0**.
- blocks added: **14**;  `\uses` edges added: **~40** (each new block's own deps + inbound
  wiring into 4 consumers).

## Blocks added / proofs written
All in `chapters/Picard_TensorObjSubstrate.tex`. Dual cluster placed in a new
`\subsection{Dual-inverse lane: the slice-transport helper declarations}` right after
`lem:slice_dual_transport`; the three §C helpers placed before `lem:sheafofmodules_hom_of_local_compat`.

Dual cluster (statement-traversable under `lem:slice_dual_transport`):
- `lem:isiso_eps_restrictscalars_appiso` → `isIso_ε_restrictScalars_appIso` — leg-(B) unit ε invertible (inv-dir). Proved directly note.
- `lem:isiso_eps_restrictscalars_appiso_hom` → `isIso_ε_restrictScalars_appIso_hom` — same, hom-dir. Proved directly.
- `def:dual_unit_ring_swap` → `dualUnitRingSwap` — codomain unit ring-iso swap `inv(ε …inv)`. Proved directly.
- `def:dual_unit_ring_swap_inv` → `dualUnitRingSwapInv` — reverse (ε itself). Proved directly.
- `def:dual_unit_ring_swap_hom` → `dualUnitRingSwapHom` — hom-direction swap `inv(ε …hom)`. Proved directly.
- `lem:dual_unit_ring_swap_comp_inv` → `dualUnitRingSwap_comp_dualUnitRingSwapInv` — round-trip `Iso.hom_inv_id`. Proved directly.
- `lem:dual_unit_ring_swap_inv_comp` → `dualUnitRingSwapInv_comp_dualUnitRingSwap` — round-trip `Iso.inv_hom_id`. Proved directly.
- `def:unit_dual_section_equiv` → `PresheafOfModules.unitDualSectionEquiv` — eval-at-1 section equivalence. Proved directly.
- `def:dual_unit_iso_gen` → `PresheafOfModules.dualUnitIsoGen` — presheaf `dual 𝟙 ≅ 𝟙` (general base). Proved directly.
- `def:presheaf_dual_unit_iso` → `presheafDualUnitIso` — scheme-level instance of the above. Proved directly.
- **`lem:slice_dual_transport_inv` → `sliceDualTransportInv` — the ∞ node.** Wrote a genuine
  self-contained informal proof (the reverse leg): component-at-`W''` formula (X-slice mirror
  of the forward leg, `(f.appIso P).hom` + `dualUnitRingSwapHom`, conjugated by the
  `image_preimage_of_le` `eqToHom`s), additivity/`O_Y(V)`-linearity by steps (i)–(iii) of
  the forward leg, naturality by thin-poset `Subsingleton.elim` + ε-naturality. Provenance:
  `\textit{Source: internal categorical construction; no external reference.}`

§C helpers (statement-traversable under `lem:sheafofmodules_hom_of_local_compat`):
- `lem:image_preimage_of_le` → `image_preimage_of_le` — down-set identity `ι_!(ι⁻¹V)=V`. Proved directly.
- `def:top_section_to_hom` → `topSectionToHom` — top-section → global hom. Proved directly.
- `lem:top_section_to_hom_app` → `topSectionToHom_app` — its sectionwise value. Proved directly.

## \uses edges added/fixed (the completeness fixes)
- `lem:slice_dual_transport` now `\uses{}` (statement **and** proof): `def:dual_unit_ring_swap`,
  `def:dual_unit_ring_swap_inv`, `def:dual_unit_ring_swap_hom`, `lem:dual_unit_ring_swap_comp_inv`,
  `lem:dual_unit_ring_swap_inv_comp`, `lem:isiso_eps_restrictscalars_appiso`,
  `lem:isiso_eps_restrictscalars_appiso_hom`, `def:dual_unit_iso_gen`, `lem:image_preimage_of_le`,
  `lem:slice_dual_transport_inv` — these are the leg-(A)/(B) ingredients its Lean construction
  invokes (toFun swap, round-trip cancellations in left/right_inv, invFun, unit handling).
- **`lem:dual_restrict_iso` now `\uses{lem:slice_dual_transport}` in its STATEMENT** (was
  proof-only). This is the structural fix that makes the whole dual cluster reachable from the
  dual lemmas: see "Key finding" below.
- `lem:dual_unit_iso` proof now `\uses{def:presheaf_dual_unit_iso}` (its presheaf core).
- `lem:scheme_modules_hom_local_section` (statement + proof) now `\uses{lem:image_preimage_of_le}`.
- `lem:sheafofmodules_hom_of_local_compat` (statement + proof) now `\uses{lem:scheme_modules_hom_local_section,
  def:top_section_to_hom, lem:top_section_to_hom_app, lem:image_preimage_of_le}`.
- Converted 8 redundant **inline** `\lean{...}` references (inside the proofs of
  `slice_dual_transport`, `homLocalSection`, `dual_unit_iso`) into `\cref{...}` to the new
  labeled blocks — eliminating the un-counted secondary `\lean` pins. Each of the 14 Lean
  names is now pinned by exactly one labeled block (verified).

## Key finding — leandag counts STATEMENT-level `\uses` only
In this project's `leandag` config, the dependency DAG is built from **statement-level
`\uses` only**; `\uses` inside a `\begin{proof}` is **not** a traversable edge
(`lem:dual_restrict_iso` had `dep_count = 2`, its statement uses, despite its proof using
`lem:slice_dual_transport`). Consequence: wiring a dependency *only* in the proof leaves the
node off the cone. The project convention (e.g. `lem:dual_isLocallyTrivial` statement
`\uses` its 3-step construction ingredients) is to put **construction ingredients in the
statement `\uses`**. I followed that: the inbound edges I added are in statements, and I
promoted `slice_dual_transport` into `dual_restrict_iso`'s statement `\uses`. After this, all
14 helpers appear in the ancestor cone of `lem:dual_isLocallyTrivial` (35 ancestors) and
`lem:dual_restrict_iso`.

## Could not complete (genuine gaps — strategy items)
None within the dual cluster. (`sliceDualTransportInv`'s Lean `sorry` is a *formalization*
residual, documented in-file with a verified recipe; its blueprint effort is now finite.)

## Notes for dispatcher
- **One edge connects the entire dual sub-DAG to the chapter goal, and it is out of my scope.**
  `lem:tensorobj_inverse_invertible` (`exists_tensorObj_inverse`, the TensorObjSubstrate goal
  block) has statement `\uses{def:scheme_modules_tensorobj, lem:tensorobj_preserves_locally_trivial,
  lem:tensorobj_restrict_iso}` — it does **NOT** `\uses{lem:dual_isLocallyTrivial}` (nor
  `lem:dual_restrict_iso`), even though in Lean the inverse it produces *is* `dual L`. So the
  whole dual lemma family (and my cluster beneath it) reaches only `lem:dual_isLocallyTrivial`,
  not the goal (goal cone = 4 nodes). Adding `lem:dual_isLocallyTrivial` (and
  `lem:dual_restrict_iso`) to the goal block's statement `\uses` is the single missing link;
  it belongs to the TensorObjSubstrate cluster a sibling walker owns. This is consistent with
  the project-wide ts297 "goal cone under-wired" finding.
- The pre-existing `\begin{lemma}`/`\end{lemma}` count imbalance (167/166) is comment noise
  from `% SOURCE QUOTE` blocks containing `"\begin{lemma}` with no commented close — not a
  structural defect, and not introduced here.

## References consulted
- None retrieved (all 14 are internal constructions; `sliceDualTransportInv` carries the
  sanctioned "internal categorical construction; no external reference" provenance). The
  pre-existing Stacks citation on `lem:dual_restrict_iso`/`lem:slice_dual_transport` was left intact.
