# blueprint-writer directive — chapter Cohomology_FlatBaseChange.tex (slug: fbcqc)

## Strategy context

This chapter backs the first ungated A.2.c-engine lane (flat base change, Stacks 02KH). iter-236
landed three axiom-clean Γ-fragment declarations; the remaining brick is the object iso
`lem:pushforward_spec_tilde_iso`. A lean-vs-blueprint check flagged two problems to fix:

## Required edits

### 1. Fix the CIRCULAR QC dependency in `lem:pushforward_spec_tilde_iso`'s proof sketch.
The current sketch's movement (3) concludes "quasi-coherence of `(Spec φ)_*(M~)` from closure
under iso, using the object iso just built" — but the object iso is built FROM `fromTildeΓ`,
which is an iso IFF the pushforward is already quasi-coherent. So QC is a PREREQUISITE, not a
corollary. Rewrite the proof sketch to use the NON-circular route (the prover's route (iii)):

Build the object iso DIRECTLY on a basis of basic opens, which yields the object iso AND
quasi-coherence simultaneously. Concretely:
- Reduce to checking the comparison map is an iso on each basic open `D(a) ⊆ Spec R`, via the
  in-file locality criterion `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis`
  (basic opens form a basis).
- On `D(a)`: sections of `(Spec φ)_*(M~)` over `D(a)` are sections of `M~` over `(Spec φ)⁻¹ D(a)
  = D(φ a)`, i.e. the localization `M[1/φa]` as an `R[1/a]`-module via restriction of scalars;
  sections of `(restrictScalars φ M)~` over `D(a)` are `(restrictScalars φ M)[1/a]`. These agree
  because `a` acts on `restrictScalars φ M` through `φ a`, so localizing `restrictScalars φ M`
  at `a` IS `M` localized at `φ a` (`IsLocalizedModule` compatibility). Hence the comparison is
  an iso on each `D(a)`.
- Quasi-coherence of the pushforward then follows because it is now exhibited as `≅ (restr M)~`,
  a tilde-module (tilde modules are QC, and QC is closed under iso). State QC AFTER the object
  iso, as a corollary — never before.

Mathlib pointers (existence-checked): `IsLocalizedModule`, `StructureSheaf`/`Spec` basic-open
sections, `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis` (project-local, this chapter).

### 2. Add three `\lean{}` lemma/definition blocks for the iter-236 Γ-fragment decls
(currently formalized but unpinned). Place them in the "affine computation" area, before
`lem:pushforward_spec_tilde_iso`:

  - `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` — the ring-square
    naturality `gsR.hom ≫ (Spec.map φ).appTop = φ ≫ gsR'.hom`, where
    `gsR = StructureSheaf.globalSectionsIso R`; proved from `Scheme.ΓSpecIso_inv_naturality`.
  - `\lean{AlgebraicGeometry.gammaPushforwardIso}` — for general `N : (Spec R').Modules`, the
    R-module iso `Γ((Spec φ)_* N) ≅ restrictScalars φ (Γ N)`; both sides peel to nested
    restrictScalars towers, reconciled via `restrictScalarsComp'App` ×2 and the ring equation
    of the previous lemma. (State the GENERAL N form as primary.)
  - `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` — tilde specialisation `N = M~`:
    compose `gammaPushforwardIso` with the tilde-Γ unit iso `Γ(M~) ≅ M`.

Each block: a one-line informal statement + a 1–2 sentence proof sketch. These are project-bespoke
supporting infra (no external source), so omit SOURCE/SOURCE QUOTE lines.

## Out of scope
- Do NOT touch the deep `thm:flat_base_change_pushforward` (Čech) sketch — it stays a documented
  open theorem.
- Do NOT add/remove `\leanok`/`\mathlibok` markers.
- Keep sketches mathematical — no Lean tactic strings.

## References
Stacks 02KH (flat base change of R^i f_*), already in references/. If you add a verbatim quote
for the QC-on-basic-opens reduction, references/stacks-coherent.tex / stacks-constructions.tex
may help, but the route-(iii) computation is standard affine algebra and a SOURCE QUOTE is not
mandatory for these project-bespoke support lemmas.
