# Blueprint-writer directive — Cohomology_FlatBaseChange.tex (FBC route pivot)

Edit ONLY `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`. (Your second
write-domain `references/**` authorizes a child reference-retriever if you need a
source you don't have; the Stacks sources you need are already in
`references/stacks-coherent.tex` and `references/stacks-schemes.tex`.)

## Strategy context (the slice that matters)

This is the "Čech-independent leg." Two `sorry`-bearing Lean decls remain in this
chapter — `affineBaseChange_pushforward_iso` (`lem:affine_base_change_pushforward`)
and `flatBaseChange_pushforward_isIso` (`thm:flat_base_change_pushforward`). The
affine *tilde dictionaries* are ALREADY PROVED and axiom-clean in Lean:
`lem:pushforward_spec_tilde_iso` (`ψ_* M̃ = (restr_φ M)~`) and
`lem:pullback_spec_tilde_iso` (`ψ^* M̃ = (R'⊗_R M)~`). Do not touch the 16 proved
nodes' statements.

The parent decomposed the affine close into two abstract-mate obligations
(`lem:base_change_map_affine_local`, `lem:pushforward_base_change_mate_cancelBaseChange`,
both `\lean{AlgebraicGeometry.TODO.*}`) and hit a "Mathlib-scale" wall plus a deferred
Mathlib `#37189` dependency. **We are pivoting the route.** Your job is to rewrite the
prose to the new route below. Keep mathematical rigor and full citation discipline
(`% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: …}`) on every externally-sourced block.

## Required changes

### 1. Affine lemma `lem:affine_base_change_pushforward` — rewrite the proof to direct-on-sections

Recast the proof so it reduces the affine base-change isomorphism **directly on global
sections** through the two proved tilde dictionaries, NOT through an abstract adjoint-mate
identification. Concretely:
- First reduction stays: by `lem:modules_isIso_iff_affineOpens` it suffices to check on
  affine opens of `S'`, reducing to the affine–affine case `S=Spec R`, `S'=Spec R'`,
  `X=Spec A`, `F=M̃` (this is the content of `lem:base_change_map_affine_local`).
- Then, in the affine–affine case, transport the section-level map `Γ(α)` through
  `lem:pullback_spec_tilde_iso` (source `↦ (R'⊗_R A)⊗_A M`) and
  `lem:pushforward_spec_tilde_iso` (target `↦ R'⊗_R M`), both as `R'`-modules, and identify
  `Γ(α)` with the canonical cancellation iso
  `TensorProduct.AlgebraTensorModule.cancelBaseChange : (R'⊗_R A)⊗_A M ≅ R'⊗_R M`,
  `(r'⊗a)⊗m ↦ r'⊗(a·m)`. cancelBaseChange is an iso with NO flatness — that closes the affine case.

### 2. The two helper lemmas — keep, repin to faithful signatures, add an element-level sketch

Keep both `lem:base_change_map_affine_local` and
`lem:pushforward_base_change_mate_cancelBaseChange` as the two named obligations of the
affine lemma (they are the honest cut: locality-reduction + section-level identification).
For each:
- Keep a `\lean{AlgebraicGeometry.TODO.<name>}` pin (the Lean declaration is intentionally
  not built yet — a scaffold pass creates it next iter), BUT write the **exact intended Lean
  signature in the prose body** so the scaffold is faithful (state the hypotheses:
  `[IsAffineHom f]`, `[F.IsQuasicoherent]`, the cartesian-square data, and the precise
  conclusion type).
- For `lem:pushforward_base_change_mate_cancelBaseChange`, the current proof sketch is **too
  thin at the crux** (it names "the coherence computation" without doing it). Add an
  **element-level sketch**: `pushforwardBaseChangeMap` is the transpose, under the
  (pullback ⊣ pushforward) adjunctions for `g` and `g'`, of `f_*` applied to the
  `((g')^*,(g')_*)`-unit `F → (g')_*(g')^* F`. On global sections, trace a generator
  `(r'⊗a)⊗m` of `(R'⊗_R A)⊗_A M` through: the unit (`m ↦ 1⊗m` style base-change of the
  module), the pushforward/restriction-of-scalars reading, and the two dictionary isos, and
  show it lands on `r'⊗(a·m)` — i.e. exactly `cancelBaseChange`. Name which adjunction
  unit/counit is expanded at each step. If the direct-on-sections route makes a separate
  abstract mate identification unnecessary (because `Γ(α)` is computed directly), say so
  explicitly and reframe this lemma as "the section-level value of `Γ(α)` equals
  `cancelBaseChange`" rather than "the abstract mate equals cancelBaseChange."

### 3. `thm:flat_base_change_pushforward` — rewrite the proof to the Čech-FREE i=0 route

The current proof body uses Čech-complex / Čech-to-cohomology spectral-sequence language,
which needs Mathlib-absent infrastructure AND contradicts the leg's "Čech-independent"
billing. For i=0 this is unnecessary. Rewrite the proof so the PRIMARY argument is:
- Reduce (local on `S'`) to `S=Spec A`, `S'=Spec B`, `A→B` flat.
- `H⁰(X,F)` is the **equalizer** `∏_i Γ(U_i,F) ⇉ ∏_{i,j} Γ(U_{ij},F)` of a finite affine
  cover `{U_i}` (this is the **sheaf condition** — Čech degree 0/1, NOT Čech cohomology;
  no Leray, no spectral sequence).
- The affine lemma `lem:affine_base_change_pushforward` identifies each base-changed term
  with the original term `⊗_A B`.
- Flatness of `A→B` makes `−⊗_A B` preserve this finite equalizer/kernel, via Mathlib
  `Module.Flat.ker_lTensor_eq` / `Module.Flat.eqLocus_lTensor_eq`
  (`Mathlib/RingTheory/Flat/Equalizer.lean`) — verify these exact names against Mathlib;
  if absent under these names, retrieve/cite the correct flat-preserves-finite-limits lemma.
- For the quasi-separated case, Mayer–Vietoris induction on the number of cover members,
  each step reducing to the separated/affine case. Remove the spectral-sequence language.

Add a `\mathlibok` Mathlib dependency anchor block (statement in project notation, `\lean{}`
naming the real Mathlib decl, marked `\mathlibok`) for the flat-preserves-equalizer lemma
you settle on. Do NOT mark `\mathlibok` on any project to-be-proved node.

## Out of scope

- Do NOT add or remove `\leanok` (the deterministic sync owns it).
- Do NOT edit any other chapter. Do NOT change the 16 proved nodes' statements.
- Do NOT redesign the abstract `pushforwardBaseChangeMap` definition itself.

## Citation discipline

Every externally-sourced block keeps `% SOURCE:` + verbatim `% SOURCE QUOTE:` (and
`% SOURCE QUOTE PROOF:` before proof envs) and a visible `\textit{Source: …}` line.
Read the verbatim quotes from `references/stacks-coherent.tex` (Tag 02KH, "Affine base
change") and `references/stacks-schemes.tex` (Tag 01I9) — do not write quotes from memory.

If a "Strategy-modifying finding" surfaces, report it in your report's
"Strategy-modifying findings" section.
