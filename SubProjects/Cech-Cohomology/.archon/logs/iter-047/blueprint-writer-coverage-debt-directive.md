# Blueprint-writer directive — clear iter-046 coverage debt + fix stale `\uses{}` on `lem:tile_section_localization`

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this chapter).

## Strategy context (the slice that matters)
The keystone leaf `lem:tile_section_localization` (Stacks 01HV(4)/01I8, per-tile section
localization) LANDED axiom-clean in iter-046 via the bundled `ModuleCat.restrictScalars`-carrier
recipe (`analogies/tile-descent-instance-shape.md`). The prover created 2 **public** supporting
declarations and 3 **private** helpers that currently have NO blueprint block — they are isolated
nodes in the leandag graph (`archon dag-query unmatched` lists them), corrupting the 1-to-1
Lean↔blueprint correspondence. Your job: restore the 1-to-1 correspondence and fix two stale
`\uses{}` edges that the lean-vs-blueprint checker flagged. This is purely a wire-up + coverage
pass — do NOT change any mathematical content, statement, or proof sketch of an existing block.

## Tasks (precise)

### 1. Add a `\begin{lemma}` block for `tileReconcileEquiv` (public `noncomputable def`)
- `\lean{AlgebraicGeometry.tileReconcileEquiv}`
- Place it immediately BEFORE the `lem:tile_section_localization` block (it is that proof's Step-4
  scaffolding).
- `\label{lem:tileReconcileEquiv}` (pick a label consistent with the chapter's convention).
- `\uses{lem:tile_scalar_compat_genV, lem:modulesSpecToSheaf_smul_eq}` — it is the `R`-linear
  equivalence whose `map_smul'` content IS `tile_scalar_compat'` (the general-V scalar compat) and
  whose underlying carrier identity is the `modulesSpecToSheaf ∘ restrict` defeq.
- Statement (project notation): for `F : (Spec R).Modules`, `g : R`, and an open `V` of
  `Spec R_g` (where `R_g = Localization.Away g`), there is an `R`-linear isomorphism
  \[
    (\mathrm{restrictScalars}_{R \to R_g})\, \Gamma(V, \widetilde{F_{(g)}})
      \;\xrightarrow{\ \sim\ }\;
      \Gamma\bigl(\iota(\,(\text{basicOpenIsoSpecAway } g)^{-1}(V)\,),\ \mathcal{F}\bigr),
  \]
  the identity on underlying elements, with `R`-linearity supplied by `tile_scalar_compat'`. Here
  `ι = specAwayToSpec g` and the right-hand open is the image open `ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ V)`.
- One-line informal proof: the underlying map is the identity (the two section modules have the
  same carrier by the `modulesSpecToSheaf ∘ restrict` carrier identity, a `rfl`); `R`-linearity is
  exactly `lem:tile_scalar_compat_genV` (the general-open scalar-compatibility), so the identity is
  an `R`-linear isomorphism.

### 2. Add a `\begin{lemma}` block for `isScalarTower_restrictScalars_obj` (public `instance`)
- `\lean{AlgebraicGeometry.isScalarTower_restrictScalars_obj}`
- `\label{lem:isScalarTower_restrictScalars_obj}`
- `\uses{}` may be empty (it consumes only Mathlib: `IsScalarTower.of_algebraMap_smul` +
  `ModuleCat.restrictScalars.smul_def'`). If the chapter already has a Mathlib anchor for either,
  you MAY cite it; otherwise leave `\uses{}` absent.
- Statement: for a ring map `algebraMap R S`, the bundled object
  `(ModuleCat.restrictScalars (algebraMap R S)).obj M` carries an `IsScalarTower R S` instance.
- One-line informal proof: `IsScalarTower.of_algebraMap_smul` applied to the restricted-scalars
  `smul` definition (`ModuleCat.restrictScalars.smul_def'`). This Prop instance is what lets the
  base-ring descent find `IsScalarTower R S` structurally on the bundled carrier (avoiding the
  noncomputable-aux-def hoist that blocked iter-045).

### 3. Bundle the 3 private helpers into an existing block's `\lean{...}` list
The following are `private` Lean decls (no standalone environment needed). Bundle each NAME into the
`\lean{...}` list of the block whose proof creates it, so the DAG sees them (per project convention:
`private` is NOT exempt from `unmatched`; bundling the name into a related decl's `\lean{}` covers it):
- `AlgebraicGeometry.tileReconcileEquiv_apply`, `AlgebraicGeometry.tileReconcileEquiv_symm_apply`
  → bundle into the new `lem:tileReconcileEquiv` block's `\lean{...}` (they are its `@[simp]` apply lemmas).
- `AlgebraicGeometry.tile_restrict_map_apply` → bundle into the `lem:tile_section_localization`
  proof block's `\lean{...}` (it is the `rfl` "tile restriction = F restriction over image opens"
  used in the transport).

### 4. Fix TWO stale `\uses{}` edges on `lem:tile_section_localization` (lean-vs-blueprint flagged)
- **Statement block** (`lem:tile_section_localization`): REMOVE `lem:qcoh_finite_presentation_cover`
  from the statement `\uses{}`. The Lean statement takes a presentation `P` directly and never
  invokes `qcoh_finite_presentation_cover`; that edge belongs on `lem:qcoh_section_isLocalizedModule`
  (which already carries it). Do NOT touch the keystone block's uses.
- **Proof block** (`lem:tile_section_localization`): the proof `\uses{}` currently lists BOTH
  `lem:tile_scalar_compat` (V=⊤) and `lem:tile_scalar_compat_genV` (V=D(f̄)). The Lean proof calls
  ONLY `tile_scalar_compat'` (the general-V case) via `tileReconcileEquiv`; it does NOT call the
  V=⊤ `tile_scalar_compat` directly. REMOVE `lem:tile_scalar_compat` from the proof `\uses{}`,
  keeping `lem:tile_scalar_compat_genV`. (Also add `lem:tileReconcileEquiv` to the proof `\uses{}`
  since Step 4 now goes through it.)

## Out of scope (do NOT touch)
- Do NOT modify `lem:qcoh_section_kernel_comparison` or `lem:qcoh_section_isLocalizedModule` blocks
  (they are complete + correct; they feed the next prover lane).
- Do NOT add or remove `\leanok` (the deterministic `sync_leanok` phase owns it).
- Do NOT change any mathematical statement or proof sketch of an existing block beyond the `\uses{}`
  edits and the Step-4 prose note above.
- Do NOT touch any other chapter.

## Citation discipline
The two new blocks are Archon-original scaffolding (no external source) — omit `% SOURCE` lines.
Cross-check nothing externally; this is a wire-up pass.

## Verification you should self-check before returning
- `archon dag-query unmatched` should drop from 6 to 1 (only the pre-existing dead
  `AlgebraicGeometry.CechAcyclic.affine` remains).
- The `lem:tile_section_localization` statement `\uses{}` no longer contains
  `lem:qcoh_finite_presentation_cover`; the proof `\uses{}` no longer contains
  `lem:tile_scalar_compat` but does contain `lem:tile_scalar_compat_genV` and `lem:tileReconcileEquiv`.
