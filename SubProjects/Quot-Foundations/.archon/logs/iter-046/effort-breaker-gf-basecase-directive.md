# Effort-breaker — GF G1 finite-type base case

## Target
`lem:gf_qcoh_fintype_finite_sections` (G1) in `blueprint/src/chapters/Picard_FlatteningStratification.tex`.

## Granularity
Fine — one mathematical claim per sub-lemma for the base case (it is the hard, Mathlib-absent piece).

## Context
G1 = "finite-type quasi-coherent `F` on `X` ⟹ `Γ(F,W)` finite over `Γ(X,W)` for affine `W`" (Stacks 01PB).
Its proof has TWO halves; the LOCALITY half is already PROVED in Lean but lacks blueprint blocks, and the
BASE CASE is unstated. Decompose accordingly.

### Half 1 — LOCALITY reduction (DONE in Lean; add coverage-debt blocks, do NOT re-derive)
Two existing axiom-clean Lean decls need blueprint blocks (currently `archon dag-query unmatched`):
- `AlgebraicGeometry.gf_finite_sections_of_basicOpen_finite_cover` — "F qcoh, W affine, `t : Finset Γ(X,W)`
  with `span t = ⊤`, and each `Module.Finite Γ(X,D(g)) Γ(F,D(g))` (g∈t) ⟹ `Module.Finite Γ(X,W) Γ(F,W)`."
  Proof: `Module.Finite.of_localizationSpan_finite`; per g the basic open is `IsLocalization.Away g` and gap2
  `isLocalizedModule_basicOpen` localizes sections; the helper below feeds the canonical-model finiteness.
  Label `lem:gf_finite_sections_of_basicOpen_finite_cover`. `\uses{lem:qcoh_section_localization_basicOpen,
  lem:finite_localizedModule_transfer}`. Mathlib anchor: `Module.Finite.of_localizationSpan_finite` (\mathlibok).
- `AlgebraicGeometry.finite_localizedModule_of_isLocalizedModule` — model-independence of localized-module
  finiteness: `Rₚ` localizes `R` at `S`, `φ:M→N` is `IsLocalizedModule S`, `N` an `Rₚ`-module ⟹ finiteness
  of `N`/`Rₚ` transfers to `LocalizedModule S M`/`Localization S`. Proof: `IsLocalizedModule.linearEquiv` +
  `IsLocalization.algEquiv` semilinear transport of a finite spanning set. Label `lem:finite_localizedModule_transfer`.

### Half 2 — finite-type BASE CASE (the gap to decompose)
The remaining claim: on a basic open / affine `V ⊆ X` (= `Spec B`, `B = Γ(X,V)`), `F.IsQuasicoherent` +
`F.IsFiniteType` ⟹ `Module.Finite B Γ(F,V)`. This feeds Half 1 (it supplies each `Module.Finite Γ(X,D(g)) …`).

**CORRECTED ROUTE (mandatory — a bare "stalkwise-epi ⟹ global-section-epi" step is FALSE in general):**
route through **affine-qcoh exactness of `Γ`** via the already-built gap1/gap2 qcoh≃Mod descent
(`Scheme.Modules.*`, `isLocalizedModule_basicOpen`, the affine `Γ`/`~` equivalence). This is exactly the
content of Stacks 01PB. Split along these seams (one claim each):
1. From `F.IsFiniteType`: on an affine `V`, finitely many generating sections give a sheaf epimorphism
   `O_V^{⊕I} ↠ F|_V` with `I` finite (extract the finite generating set on `V` from `IsFiniteType`/
   `GeneratingSections`/`LocalGeneratorsData`).
2. `Γ` on affine quasi-coherent sheaves is exact / preserves epimorphisms (transport across the gap1/gap2
   descent equivalence: a qcoh sheaf epi ↦ a surjective module map). Hence `Γ(O_V^{⊕I}) = B^{⊕I} ↠ Γ(F,V)`
   is a surjective `B`-module map. State the precise input from the descent that you rely on (sheaf-epi ↦
   module-epi) — if it is not yet a named lemma, create a sub-lemma node for it with its own \uses.
3. A finite-rank free module surjecting onto `N` ⟹ `Module.Finite B N` (`Module.Finite.of_surjective` /
   from a finite spanning image). Mathlib anchor where applicable (\mathlibok).
Then rewire G1's proof block: `\uses{lem:gf_finite_sections_of_basicOpen_finite_cover, <base-case label>}` —
pick the IsFiniteType cover, apply the base case on each `D(gᵢ)`, glue via Half 1.

## Constraints
- Each new/changed block: statement, `\label{}`, `\lean{}` (use real names for the 2 existing helpers; for
  base-case pieces not yet in Lean, pin the intended `AlgebraicGeometry.<name>` you propose), accurate
  `\uses{}`, a real one-paragraph informal proof. NO Lean tactic syntax.
- Cite Stacks 01PB (read from `references/stacks-properties.tex`) for the base case; keep the existing
  `% SOURCE`/`% SOURCE QUOTE` discipline.
- Do NOT add `\leanok` (sync_leanok's job). `\mathlibok` only on genuine Mathlib anchors named above.
- Edit ONLY `blueprint/src/chapters/Picard_FlatteningStratification.tex`.
