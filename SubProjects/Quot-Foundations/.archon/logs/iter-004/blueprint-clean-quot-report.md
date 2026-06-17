# blueprint-clean-quot report (iter-004)

**File touched:** `blueprint/src/chapters/Picard_QuotScheme.tex` only.

---

## Fixes applied

### 1. Section intro `sec:quot_predicates`
Removed encoding-rationale language ("not yet primitive in the underlying sheaf-of-modules formalism", "This section encodes both predicates") and Lean predicate names `\mathcal{G}.\mathrm{IsQuasicoherent}` / `\mathcal{G}.\mathrm{IsFiniteType}`. Section now reads as a clean mathematical introduction.

### 2. `def:modules_annihilator`
- **Lean leakage removed:** `X.\mathrm{Modules}`, `\mathrm{SheafOfModules}\,(X.\mathrm{ringCatSheaf})`, `X.\mathrm{IdealSheafData}`, `\mathrm{ofIdeals}(U \mapsto \mathrm{Ann}_{\Gamma(X,U)}\,\Gamma(\mathcal{F},U))`.
- **Replaced with** a clean affine-local definition using standard notation: `\mathrm{Ann}(\mathcal{F})(U) = \mathrm{Ann}_{\mathcal{O}_X(U)}(\mathcal{F}(U))`.
- **Note stripped of:** Lean file references (`IdealSheaf/Basic.lean`, `RingTheory/Ideal/Colon.lean`), Lean declaration names (`IdealSheafData.ofIdeals`, `RingHom.ker`, `Module.annihilator`, `AlgebraicGeometry.Scheme.Hom.ker`). Replaced with one-sentence "project-built primitive; Mathlib does not carry an annihilator for sheaves of modules on a scheme."
- **`\textit{Source:}` updated** to drop "see the note below".

### 3. `def:schematic_support`
- **Lean leakage removed:** `\bigl(\mathrm{Ann}(\mathcal{F})\bigr).\mathrm{subscheme}` (dot-access), `\mathrm{subscheme}\iota` (dot-field subscript), `\mathrm{IdealSheafData.subscheme}`, `\texttt{IdealSheaf/Subscheme.lean}`, "preimmersion and quasi-compact" machinery text.
- **Replaced with** standard closed-subscheme notation: `V(\mathrm{Ann}(\mathcal{F})) \hookrightarrow X`.

### 4. `lem:isProper_mathlib`
- **Lean leakage removed:** `\mathrm{MorphismProperty}`, `\mathrm{IsProper.isStableUnderBaseChange}`, the formula display `\mathrm{IsProper} = (\mathrm{IsSeparated} \sqcap \mathrm{UniversallyClosed}) \sqcap \mathrm{LocallyOfFiniteType}` (Lean typeclass intersection syntax).
- **Replaced with** a clean mathematical statement: "A morphism f : X → S is proper iff it is separated, universally closed, and locally of finite type." with a prose statement of base-change stability.
- **`\mathlibok` verified:** names `AlgebraicGeometry.IsProper` — a genuine Mathlib declaration (`Mathlib.AlgebraicGeometry.Morphisms.Proper`). ✓

### 5. `def:has_proper_support`
- **Lean leakage removed:** `\mathrm{HasProperSupport}\,f\,\mathcal{F} :\Longleftrightarrow \mathrm{IsProper}(...)` (Lean curried-application syntax), `\bigl(\mathrm{Ann}(\mathcal{F})\bigr).\mathrm{subscheme}\iota` (dot-field access).
- **Encoding rationale removed:** "Reusing IsProper rather than re-bundling separatedness, universal closedness, and finite type by hand makes the base-change stability of proper support immediate."
- **Replaced with** the composite-morphism display: `schematicSupport(F) ↪ X →f S is proper`, with a clean base-change remark.

### 6. `def:is_locally_free_of_rank`
- **Lean leakage removed:** Full "Encoding note" section (20+ lines), including references to `\mathrm{Nonempty}(...)`, `\mathrm{free}(\mathrm{Fin}\,r)`, `\mathrm{SheafOfModules.free}`, `\mathrm{freeFunctor}`, `\mathrm{mapFree}`, `\mathrm{rankAtStalk}`, `\mathrm{Module.rankAtStalk}`, `\mathrm{PrimeSpectrum}`, `\mathrm{IsQuasicoherent}`, `\mathrm{QuasicoherentData}`, `\mathrm{IsFinitePresentation}`, `\mathrm{IsFiniteType}`, `\texttt{Sheaf/Quasicoherent.lean}`, `\texttt{Sheaf/Generators.lean}`, `\texttt{Sheaf/Free.lean}`.
- **Body rewritten** as standard math: "there exists an open cover {U_i} of X together with isomorphisms M|_{U_i} ≅ O_{U_i}^{⊕d}".
- **Variable**: renamed `r` → `d` consistently (matching the section header "rank \(d\)").

### 7. `def:quot_functor` item 1
- **Lean leakage removed:** `\mathcal{F}.\mathrm{IsQuasicoherent}` and `\mathcal{F}.\mathrm{IsFiniteType}` predicate names; "Coherence is encoded by the two object predicates..."; "properness of the schematic support over T is HasProperSupport...along the structure morphism".
- **Replaced with** a single clean clause: "whose schematic support is proper over T (\cref{def:has_proper_support}) and which is flat over T".

### 8. `def:grassmannian_scheme`
- **Encoding rationale removed:** "Structurally...not as a second, independently-built functor. Fixing the definition this way makes the identity...hold by construction, so the structural correspondence is preserved automatically when the underlying Quot construction is later filled in, and the Grassmannian inherits its functoriality and equivalence relation from the Quot functor rather than restating them."
- **Lean leakage removed:** `\mathrm{IsLocallyFreeOfRank}\,\mathcal{F}\,d` (Lean curried application).
- **Replaced with** a single sentence restating the mathematical identity, merged cleanly with the pre-existing "Concretely..." sentence.

---

## Source-citation audit (new blocks)

| Block | `% SOURCE:` | `% SOURCE QUOTE:` | `\textit{Source:}` |
|-------|-------------|-------------------|---------------------|
| `def:modules_annihilator` | ✓ Nitsure §1 L468-471 | ✓ verbatim from Nitsure | ✓ |
| `def:schematic_support` | ✓ Nitsure §1 L468-471 | ✓ verbatim from Nitsure | ✓ |
| `lem:isProper_mathlib` | — (Mathlib block, no Nitsure source) | — | ✓ `\textit{Provided by Mathlib...}` |
| `def:has_proper_support` | ✓ Nitsure §1 L407-409+418-419 | ✓ verbatim from Nitsure | ✓ |
| `def:is_locally_free_of_rank` | ✓ Nitsure §1 L562-564+584-585 | ✓ verbatim from Nitsure | ✓ |

All new Nitsure-derived blocks carry complete source attribution.

---

## Marker audit

| Block | `\mathlibok` | `\leanok` | Correct? |
|-------|-------------|----------|----------|
| `def:modules_annihilator` | — | — | ✓ (project-built) |
| `def:schematic_support` | — | — | ✓ (project-built) |
| `lem:isProper_mathlib` | ✓ | — | ✓ (genuine Mathlib: `AlgebraicGeometry.IsProper`) |
| `def:has_proper_support` | — | — | ✓ (project-built) |
| `def:is_locally_free_of_rank` | — | — | ✓ (project-built) |
| `lem:hilbertPoly_exists_mathlib` | ✓ | — | ✓ (pre-existing Mathlib) |
| `lem:functor_is_representable_mathlib` | ✓ | — | ✓ (pre-existing Mathlib) |
| `def:hilbert_polynomial` | — | ✓ | ✓ (pre-existing, not touched) |
| `def:quot_functor` | — | ✓ | ✓ (pre-existing, not touched) |
| `def:grassmannian_scheme` | — | ✓ | ✓ (pre-existing, not touched) |
| `thm:grassmannian_representable` | — | ✓ | ✓ (pre-existing, not touched) |

No project-built block carries `\mathlibok` or `\leanok`. ✓

---

## LaTeX environment balance

22 `\begin{...}` / 22 `\end{...}` — perfectly balanced.

| Environment | Count |
|-------------|-------|
| `definition` | 11 open / 11 close |
| `lemma` | 5 open / 5 close |
| `theorem` | 2 open / 2 close |
| `proof` | 4 open / 4 close |

---

## `\uses` / `\cref` resolution

- `def:schematic_support \uses{def:modules_annihilator}` — label defined at line 430. ✓
- `def:has_proper_support \uses{def:schematic_support, lem:isProper_mathlib}` — both defined. ✓
- `def:quot_functor \uses{def:hilbert_polynomial, def:has_proper_support}` — both defined. ✓
- `def:grassmannian_scheme \uses{def:quot_functor, def:is_locally_free_of_rank}` — both defined. ✓
- All `\cref{}` calls in newly edited prose reference labels that exist in this chapter. ✓

---

## Not touched (per directive)

- `thm:grassmannian_representable` proof sketch and its deferred-open-question `% NOTE:` — unchanged.
- All `\leanok` markers — unchanged.
- All other chapters — unchanged.
