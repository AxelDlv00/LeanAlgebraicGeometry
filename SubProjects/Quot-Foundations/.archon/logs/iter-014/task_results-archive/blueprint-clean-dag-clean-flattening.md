# Blueprint Clean Report — dag-clean-flattening

**Chapter:** `blueprint/src/chapters/Picard_FlatteningStratification.tex`

## Summary

Full audit completed. All rendered (non-`%`-comment) text cleaned of Lean leakage, project history, and verbosity. No LaTeX structural issues found. No new citations required.

---

## Changes Made

### 1. Lean leakage stripped from statement bodies

| Location | Issue | Fix |
|---|---|---|
| `thm:generic_flatness_algebraic` | Lean-encoding paragraph (`\texttt{LocalizedModule (Submonoid.powers f) M}` etc.) after the mathematical statement | Removed entirely |
| `lem:fp_free_descent` | `\texttt{Localization.Away}~r` in statement | Replaced with `R_r` |
| `lem:gf_splice_shortExact_localized_exact` | Trailing `\texttt{Localization.Away}~f` / `\texttt{LocalizedModule ...}` explanation | Removed; sentence ends after `q_f` is surjective |
| `lem:gf_noether_clear_denominators` | `\texttt{Localization.Away}~g`, `\texttt{Localization.Away (algebraMap A B g)}`, `\texttt{MvPolynomial (Fin n)~A_g}` | Replaced with `A_g = A[g^{-1}]`, `B_g = B[g^{-1}]`, and plain polynomial-ring notation |
| `lem:gf_leadingCoeff_finSuccEquiv_t` | `\mathrm{finSuccEquiv}` as a Lean function name; `c_v \in k \hookrightarrow k[X_1,…]` (coercion notation) | Rewritten: "viewing … as a univariate polynomial … its leading coefficient in X₀ is the constant cᵥ ∈ k" |
| `lem:gf_T_leadingcoeff_eq` | `\mathrm{C}(c_v)` (Lean `Polynomial.C` constructor); `\mathrm{coeff}_v f` | Replaced with "constant cᵥ := [Xᵛ]f" |
| `lem:gf_degreeOf_t_ne_of_ne` | `\mathrm{coeff}_v f`, `\mathrm{coeff}_w f` | Replaced with "where cᵥ, cw are the corresponding coefficients of f" |
| `lem:gf_finSuccEquiv_map_comm` | Lean term-mode displayed equation with `\mathrm{finSuccEquiv}_B(…) = \mathrm{Polynomial.map}(…)` | Rewritten as: "the isomorphism A[X₀,…,Xₘ] ≅ (A[X₁,…,Xₘ])[X₀] is natural with respect to applying φ coefficientwise" |
| `lem:gf_finSuccEquiv_rename_succ` | `\mathrm{rename}\,\mathrm{succ}`, `\mathrm{C}(s)`, `\mathrm{optionEquivLeft}` | Rewritten in plain math; title changed from "`finSuccEquiv` of a constant-variable inclusion" to "Constant inclusion under the variable-splitting isomorphism" |
| `lem:gf_nagata_monic_lastVar` | `\texttt{finSuccEquiv}` in statement | Replaced with "viewed as a univariate polynomial in X₀ over Ag[X₁,…,Xₙ]" |
| `lem:gf_mvPolynomial_quotient_finite_monic` | `(\texttt{finSuccEquiv})` parenthetical in statement | Removed |
| `lem:gf_flat_finite` | `\texttt{LocalizedModule (Submonoid.powers f) M}`, `\texttt{Localization.Away f}` | Replaced with Mf flat over Af |
| `lem:gf_free_moduleFinite` | `(\texttt{[Module.Finite A B]})`, `(\texttt{[Module.Finite B M]})`, `\texttt{LocalizedModule…}`, `\texttt{Localization.Away f}` | All replaced with plain math |
| `thm:generic_flatness` | Mathlib-encoding paragraph (`\texttt{IsCoherent}`, `\texttt{SheafOfModules.IsQuasicoherent}`, `\texttt{SheafOfModules.IsFiniteType}`) | Reduced to one sentence: "The coherence hypothesis is essential: a non-coherent module need not become flat over any non-empty open." |

### 2. Lean leakage stripped from proof bodies

| Location | Issue | Fix |
|---|---|---|
| `lem:gf_splice_shortExact_localized_exact` proof | `\texttt{LocalizedModule.map\_exact}` Mathlib API call | Removed; replaced with "Proved directly in Lean." |
| `lem:gf_finite_module` proof | "already closed in Lean axiom-clean" | Removed; "This is the d=0 leaf of the induction." |
| `lem:gf_T_leadingcoeff_eq` proof | `\mathrm{C}(c_v)` | Replaced with "constant cᵥ" |
| `lem:gf_torsion_reindex` proof | `\texttt{finSuccEquiv}` in two places | Replaced with mathematical descriptions |
| `lem:gf_flat_finite` proof | `\texttt{Module.Flat.of\_free}` | Removed; "free modules are flat" |
| `lem:gf_free_moduleFinite` proof | `\texttt{Module.Finite.trans}`, `\texttt{LocalizedModule…}`, `\texttt{Localization.Away f}`; verbose "strictly more general" paragraph | Replaced with 2-sentence clean proof |
| `thm:generic_flatness_algebraic` proof (primary route) | `\texttt{Module.FinitePresentation.exists\_free\_localizedModule\_powers}`, `\texttt{Mathlib.RingTheory.Localization.Free}`, `\texttt{Module.freeLocus}`, `\texttt{Mathlib.RingTheory.Spectrum.Prime.FreeLocus}` | All removed; replaced with reference to `lem:gf_finite_module` |
| `thm:generic_flatness` proof | `\texttt{exists\_isAffineOpen\_mem\_and\_subset}`, `\texttt{SheafOfModules.IsQuasicoherent}`, `\texttt{SheafOfModules.IsFiniteType}`, `\texttt{Module.Flat.of\_free}`, `\texttt{Module.flat\_of\_isLocalized\_maximal}` | All removed; replaced with mathematical descriptions |

### 3. Project history removed from rendered text

| Location | Issue | Fix |
|---|---|---|
| `sec:gf_nagata_machinery` intro | "file-internal helpers in the `\texttt{GenericFreeness}` namespace", "project-internal technical lemmas", "an Archon transcription of", "each is recorded below so the Lean↔blueprint correspondence is one-to-one" | Rewritten as plain mathematical introduction |
| `sec:gf_finite_helpers` intro | "file-internal helpers in the `\texttt{GenericFreeness}` namespace", "Both are already proved axiom-clean" | Replaced with clean two-line description |
| `lem:gf_polynomial_core` statement | "This is the genuine Mathlib-absent residue of generic freeness: the bottom of the Nitsure §4 induction, on which the whole finite-type case rests." | Removed |
| Proof fallback label | `\emph{Fallback (Nitsure §4 induction), as a \texttt{\textbackslash uses}-linked chain.}` | Cleaned to `\emph{Fallback (Nitsure §4 induction).}` |
| Devissage chain intro | `\texttt{\textbackslash uses} only earlier blocks (or Mathlib anchors)` | Replaced with "depends only on earlier blocks or Mathlib lemmas" |
| Nagata section intro | `The distinguished variable singled out by \(\mathrm{finSuccEquiv}\) is X₀` | Replaced with "The distinguished variable is X₀" |
| Mathlib status section | "file-internal `\texttt{GenericFreeness}` namespace already lands the finite-module / finite-morphism special case axiom-clean" | Removed trailing sentence |

### 4. Concision

- `lem:gf_free_moduleFinite` proof trimmed from 10 lines to 3 lines
- `thm:generic_flatness_algebraic` primary-route description trimmed from 16 lines to 6 lines

### 5. LaTeX / refs

- All `\label{}`, `\lean{}`, `\uses{}` entries verified well-formed; no changes needed
- No literal `REF` tokens found
- No interleaved math delimiters found
- `\leanok` and `\mathlibok` markers left untouched

### 6. Citations

All pre-existing `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` blocks retained intact. No new helper blocks required external citations (all project-internal Nagata helpers and finite-module helpers derive from the Nitsure §4 source already quoted in the surrounding context). No citations fabricated.

## Status

Chapter is clean. No further blueprint-clean action required this iteration.
