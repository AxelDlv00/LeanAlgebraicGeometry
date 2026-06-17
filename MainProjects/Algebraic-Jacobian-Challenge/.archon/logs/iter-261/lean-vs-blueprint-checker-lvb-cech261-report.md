# Lean ↔ Blueprint Check Report

## Slug
lvb-cech261

## Iteration
261

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Build status
File builds clean: 0 errors, exactly 5 sorry warnings (lines 89, 118, 144, 181, 241) matching
the declared "5 typed sorry, 1 real def" in the directive. No axiom warnings.

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: `def:cech_nerve`)
- **Lean target exists**: yes (line 89)
- **Signature matches**: partial — see notes
- **Proof follows sketch**: N/A (body is `:= sorry`; sketch in docstring matches blueprint §Čech nerve)
- **Notes**:
  The Lean type is `CosimplicialObject.Augmented X.Modules` (correctly cosimplicial).
  The blueprint `def:cech_nerve` says "the augmented **simplicial** object in QCoh(X)…
  whose object in **simplicial** degree p is…" — both occurrences of "simplicial" should
  be "cosimplicial". The Lean is correct; the blueprint has the wrong categorical direction.
  The content-level formula `[p] ↦ ∏_{(i₀,…,i_p)} (j_{i₀…i_p})_*(…)` is still correct
  (indices grow with p, consistent with a cosimplicial structure), but a prover following
  the prose would likely try `SimplicialObject.Augmented` first and fail.
  Additionally, the Lean does **not** require `hF : F.IsQuasicoherent`; the blueprint says
  "any chosen quasi-coherent sheaf". This is acceptable for a sorry scaffold.

### `\lean{AlgebraicGeometry.CechComplex}` (chapter: `def:cech_complex`)
- **Lean target exists**: yes (line 118)
- **Signature matches**: partial — see notes
- **Proof follows sketch**: N/A (body is `:= sorry`)
- **Notes**:
  The Lean signature `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) : CochainComplex S.Modules ℕ`
  implements the **relative** Čech complex (pushforward over each intersection to QCoh(S)).
  The blueprint definition block first describes the **absolute** Čech complex using "global-sections
  functor" (computing H^p(X,F)) and only pivots to the relative version in the final paragraph.
  The `\lean{AlgebraicGeometry.CechComplex}` annotation is attached to this combined block,
  but the Lean only implements the relative version. A prover reading the first paragraph in
  isolation would build the wrong thing.
  No separatedness or QC hypotheses appear in the Lean signature (blueprint says "all
  intersections affine, e.g. X separated"); acceptable for an unconditional formal definition
  since the body is sorry.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 144)
- **Signature matches**: partial — see notes
- **Proof follows sketch**: partial — sketch present in docstring and blueprint proof block; both use prime-local contracting homotopy. Body is `:= sorry`.
- **Notes**:
  Blueprint statement: "Let U = Spec(A) affine, F quasi-coherent, U a finite standard open cover.
  Then Ȟ^p(U,F) = 0 for p > 0." — an **absolute** statement (no base scheme S, no morphism f).
  Lean statement: uses the **relative** `CechComplex f 𝒰 F` with hypotheses `[IsAffine X]`
  and `[IsAffineHom f]`. Mathematically equivalent (affine X + affine f gives affine S is a
  standard reduction), but the blueprint does not mention S or f at all, so the Lean signature
  does not literally match the blueprint prose.
  Also: blueprint says "standard open cover (D(fᵢ) with fᵢ generating the unit ideal)" but
  Lean uses a general `X.OpenCover` without the "standard" qualifier. For a sorry placeholder
  this is acceptable.
  The `\leanok` marker is correct (declaration exists).

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`)
- **Lean target exists**: yes (line 181)
- **Signature matches**: yes, with one extra hypothesis (see notes)
- **Proof follows sketch**: N/A (body is `:= sorry`; sketch in docstring and blueprint proof block consistent)
- **Notes**:
  Blueprint states: "for every i ≥ 0 there is a canonical isomorphism H^i(Č•(U,F)) ≅ R^i f_* F."
  Lean adds `[HasInjectiveResolutions X.Modules]` not present in the blueprint prose. This is
  necessary to reference `higherDirectImage f i F` from `HigherDirectImage.lean` (which is defined
  as a right derived functor requiring enough injectives). The blueprint should note this extra
  hypothesis or phrase the statement as comparing against the derived-functor definition under the
  hypothesis.
  The `Nonempty (… ≅ …)` packaging is acknowledged as honest in the directive (comparison map
  not yet constructed). The `\leanok` marker is correct.

### `\lean{AlgebraicGeometry.cechHigherDirectImage}` (chapter: `def:cech_higher_direct_image`)
- **Lean target exists**: yes (line 209–211)
- **Signature matches**: yes
- **Proof follows sketch**: yes — real body `(CechComplex f 𝒰 F).homology i` exactly matches
  the definition "H^i(Č•(U,F))" in the blueprint; no sorry.
- **Notes**:
  Blueprint says "For f : X → S separated quasi-compact, F quasi-coherent, U a finite affine
  open cover…" — but the Lean definition has **no** such hypotheses. This is intentional: the
  definition is unconditional (body is a well-typed formal cohomology), and the blueprint
  paragraph that follows explains the independence-of-cover argument using
  `cech_computes_higherDirectImage`. This design choice (unconditional definition, conditional
  properties proved separately) is sound but the blueprint should explicitly note that the
  Lean signature drops the hypotheses from the definition.
  Return type `S.Modules` is consistent with the blueprint's "QCoh(S)" since `Scheme.Modules`
  in this project represents quasi-coherent sheaves.

### `\lean{AlgebraicGeometry.cech_flatBaseChange}` (chapter: `lem:cech_flat_base_change`)
- **Lean target exists**: yes (line 241)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (body is `:= sorry`; sketch in docstring and blueprint proof block consistent)
- **Notes**:
  Cartesian square formalized via `(h : IsPullback g' f' f g)` — standard Mathlib idiom, matches
  blueprint. `[Flat g]` matches "g flat". `[QuasiCompact f]` / `[IsSeparated f]` match blueprint
  "f separated quasi-compact". `Nonempty (… ≅ …)` packaging is honest. Two explicit affine covers
  `𝒰` for X and `𝒰'` for X' are parameterized separately — this is finer than the blueprint
  which speaks of base-changing the cover, but is a valid and honest representation.
  The `\leanok` marker is correct.

---

## Red flags

### Placeholder / suspect bodies
- `CechNerve` (line 89): `:= sorry` — scaffold; blueprint describes a substantive construction but
  explicitly notes "currently absent from Mathlib for `Scheme.Modules`". The docstring and blueprint
  are honest: this is a typed scaffold, not a hidden placeholder.
- `CechComplex` (line 118): `:= sorry` — same situation.
- `CechAcyclic.affine` (line 144): `:= sorry` — scaffold; the blueprint proof block is detailed.
- `cech_computes_higherDirectImage` (line 181): `:= sorry` — scaffold; detailed proof sketch present.
- `cech_flatBaseChange` (line 241): `:= sorry` — scaffold; detailed proof sketch present.

**None of these are "must-fix" placeholder red flags**: the directive explicitly authorizes 5 typed
sorries on this new scaffold file, the mathematical content is substantive (not trivially-true),
and every sorry body is accompanied by an honest explanation of what Mathlib infrastructure is
missing.

### Excuse-comments
None found. The in-body comments explain what mathematical infrastructure is absent ("currently
absent from Mathlib for `Scheme.Modules`") — these are accurate capability assessments, not
excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None found (`lean_diagnostic_messages` returned 0 errors; no `axiom` declarations in file).

---

## Unreferenced declarations (informational)
All 6 declarations in the Lean file are `\lean{...}`-referenced from the blueprint.
No unreferenced declarations to flag.

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 Lean declarations have a `\lean{...}` block. 0 unreferenced. Complete.

- **Proof-sketch depth**: **adequate** for the three lemmas (`CechAcyclic.affine`,
  `cech_computes_higherDirectImage`, `cech_flatBaseChange`). Each has a detailed proof block
  with the Stacks argument, localisation steps, spectral-sequence collapse, and flatness
  exactness argument — enough for a prover to work from. The two definition blocks
  (`CechNerve`, `CechComplex`) appropriately note what Mathlib machinery is absent.

- **Hint precision**: **precise** for all six `\lean{...}` hints — all names match the actual
  Lean declarations exactly, including capitalisation (CechNerve, CechComplex) and
  underscore/camelCase choices (cech_computes_higherDirectImage, cechHigherDirectImage,
  cech_flatBaseChange).

- **Generality**: matches need.

- **Recommended chapter-side actions**:

  1. **[MAJOR — blueprint error]** `def:cech_nerve`: Replace "augmented **simplicial** object
     in QCoh(X)" with "augmented **cosimplicial** object in QCoh(X)" and replace "**simplicial**
     degree p" with "**cosimplicial** degree p". The Lean `CosimplicialObject.Augmented` is
     correct; the blueprint has the wrong categorical variance. A prover following the prose
     literally would instantiate the wrong type.

  2. **[MAJOR — blueprint clarity]** `def:cech_complex`: The definition block introduces the
     absolute Čech complex (global-sections version) first, then mentions the relative version
     as a closing remark. But `\lean{AlgebraicGeometry.CechComplex}` targets **only** the
     relative complex. Restructure the block so the relative complex is primary (matching the
     Lean signature `(f : X ⟶ S) → CochainComplex S.Modules ℕ`), with a note that setting
     `S = pt` and `f` the structure map recovers global Čech cohomology.

  3. **[MINOR]** `lem:cech_acyclic_affine`: The blueprint states an absolute affine vanishing
     (no S, no f), while the Lean statement uses the relative `CechComplex f 𝒰 F` with
     `[IsAffineHom f]`. Update the blueprint statement to mention f and S explicitly, or add
     a remark that the Lean version is relative (includes an affine morphism f : X → S).

  4. **[MINOR]** `lem:cech_computes_cohomology`: Note in the statement block that the Lean
     adds the hypothesis `[HasInjectiveResolutions X.Modules]` (needed to reference the
     derived-functor `higherDirectImage`). The blueprint statement "…there is a canonical
     isomorphism H^i(Č•(U,F)) ≅ R^i f_* F" gives the impression the isomorphism holds
     unconditionally; clarify that the right side is the derived-functor definition, which
     requires enough injectives.

  5. **[MINOR]** `def:cech_higher_direct_image`: Add a remark that the Lean definition is
     intentionally **unconditional** — no separatedness, QC, or quasi-coherence hypothesis in
     the type signature — and that the QC and cover-independence properties are consequences
     proved in `cech_computes_higherDirectImage`.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Blueprint `def:cech_nerve`: "simplicial" should be "cosimplicial" | **MAJOR** |
| Blueprint `def:cech_complex`: absolute complex described first; relative version is what `\lean{CechComplex}` targets | **MAJOR** |
| `CechAcyclic.affine`: blueprint is absolute; Lean is relative; blueprint should match | **MINOR** |
| `cech_computes_higherDirectImage`: missing `[HasInjectiveResolutions]` note in blueprint | **MINOR** |
| `cechHigherDirectImage`: blueprint doesn't note that definition is unconditional | **MINOR** |

**Overall verdict**: The Lean file is an honest, well-documented scaffold — correct types (no
fake True-statements), 5 typed sorries with detailed proof sketches, 1 real definition with real
body, builds clean. Blueprint coverage is complete (6/6). Two **major** blueprint inaccuracies
require chapter-side fixes before provers work on `CechNerve` or `CechComplex`: the
"simplicial" vs "cosimplicial" terminology error, and the absolute-vs-relative complex
definition ambiguity.

**6 declarations checked, 2 major blueprint inaccuracies, 0 Lean-side red flags.**
