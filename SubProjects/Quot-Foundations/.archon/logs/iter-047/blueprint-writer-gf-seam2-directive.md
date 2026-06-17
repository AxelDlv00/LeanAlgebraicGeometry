# Blueprint-writer directive — GF seam 2 mechanism refinement

Target: `blueprint/src/chapters/Picard_FlatteningStratification.tex`
Scope: ONLY the lemma `lem:gf_affine_qcoh_Gamma_epi` (seam 2, ~L1657–1696). Do not touch any other block.

## Action
Replace the proof prose's hand-wave — "Global sections of a quasi-coherent sheaf on an affine are
exact (the affine has no higher quasi-coherent cohomology)" — with the concrete, Mathlib-aligned
mechanism the analogist verified. Read `analogies/gf-gamma-exact.md` (already written) for the full
ingredient list and citations before editing.

Concrete mechanism (rewrite the proof to this; project notation, no Lean tactics):
- On the affine `Spec R`, Mathlib's `AlgebraicGeometry.tilde.adjunction : tilde.functor R ⊣
  moduleSpecΓFunctor` realizes the associated-sheaf/section adjunction; `moduleSpecΓFunctor` is the
  affine section functor `Γ`.
- Its counit is `AlgebraicGeometry.Scheme.Modules.fromTildeΓNatTrans`, natural, with
  `.app M = M.fromTildeΓ` definitionally.
- For quasi-coherent `G, F`, the bridge `IsIso _.fromTildeΓ` holds (project G1-core
  `isIso_fromTildeΓ_of_isLocalizedModule_restrict`, the qcoh ⟹ IsIso-counit feeder).
- Counit naturality on `π` gives `tilde.functor.map (Γ π) = G.fromTildeΓ ≫ π ≫ inv F.fromTildeΓ`,
  an epi (iso ∘ epi ∘ iso).
- `tilde.functor R` is faithful, hence reflects epimorphisms, so `Γ π` is an epi in `ModuleCat R`,
  i.e. `Γ π` is surjective. (NO H¹-vanishing / "Γ exact" needed — the faithful-reflects-epi step
  delivers the same content.)

## Anchors & uses
- Add one `\mathlibok` Mathlib-dependency anchor block stating the affine adjunction + counit
  (`\lean{AlgebraicGeometry.tilde.adjunction}`), in project notation, citing
  `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`. Mark it `\mathlibok` (this is a genuine Mathlib
  anchor, not a project obligation).
- Update `lem:gf_affine_qcoh_Gamma_epi`'s `\uses{}` (statement + proof) to cite the new anchor and
  the project counit-iso feeder (`isIso_fromTildeΓ_of_isLocalizedModule_restrict`'s blueprint label if
  one exists — check; otherwise cite `lem:qcoh_affine_section_localization` which already gives the
  IsIso bridge). Keep the `% SOURCE`/`% SOURCE QUOTE PROOF` Stacks 01PB citation block intact.

## Constraints
- One chapter only. Statement of seam 2 is UNCHANGED (only proof prose + uses + the new anchor).
- Do NOT add or remove `\leanok` (sync_leanok owns it). `\mathlibok` only on the new Mathlib anchor.
- No Lean tactic strings in prose. Keep it textbook-level mathematical.
- Cite verbatim only from sources you actually read (the analogies file is project-internal context,
  not a citable source; Tilde.lean decls are named, not quoted).
