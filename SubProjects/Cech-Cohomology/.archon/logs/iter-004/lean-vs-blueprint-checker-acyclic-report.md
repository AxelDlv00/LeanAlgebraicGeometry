# Lean ↔ Blueprint Check Report

## Slug
acyclic

## Iteration
004

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

---

## Per-declaration

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` (chapter: `lem:injective_resolution_of_ses`)
- **Lean target exists**: NO
- **Signature matches**: N/A (no declaration to compare)
- **Proof follows sketch**: N/A
- **Notes**:
  - `lean_verify` returns `Unknown constant '_root_.CategoryTheory.InjectiveResolution.ofShortExact'` — confirmed absent from the Lean environment.
  - `lean_local_search` and `lean_file_outline` do report a match at line 283, but examination reveals this is a **false positive from LSP code-fence parsing**: the strategy comment block (`/-! ... -/`, lines 197–347) contains a "suggested output type" code fence:
    ````
    Output type (suggested):
    ```
    def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜) ...
    ```
    or equivalently expose the SES directly as a field.
    ````
    The LSP parses the backtick-fenced snippet as a real declaration; the `type_signature` in the outline leaks comment prose confirming it is not elaborated Lean. The directive explicitly excludes declarations "appearing inside a `/-! ... -/` comment or a code fence."
  - **The blueprint carries `\leanok` on BOTH the statement block (`\begin{lemma}\leanok`, blueprint line 190) and the proof block (`\leanok`, blueprint line 217).** These are FALSE DONE MARKERS. `sync_leanok` was almost certainly fooled by the same LSP code-fence parsing bug.
  - The Lean file's own status comment (lines 197–230) states: "the horseshoe is the sole remaining blocker" and "What remains (TARGET 1, the genuine gap): the ℕ-recursion building `I_B.cocomplex`..." — the prover is fully aware this is unfinished.

### `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic}` (chapter: `lem:acyclic_dimension_shift`)
- **Lean target exists**: NO
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**:
  - `lean_local_search` returns no results; `lean_verify` was not run (search already failed).
  - Blueprint correctly carries **no** `\leanok` on the statement block (line 252: `\begin{lemma}[Dimension shift...]`) or its proof block. Status markers are accurate.
  - Partial progress exists: `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (line 153) implements the core dimension-shift logic at the *resolution level* (takes explicit chain maps `φ, ψ` with degreewise splittings), but the blueprint's named target `rightDerivedShiftIsoOfAcyclic` operates at the *object level* (takes a SES of objects and internally applies the horseshoe). The latter requires `InjectiveResolution.ofShortExact` as a prerequisite.
  - The discrepancy between the blueprint-named target and the actual Lean declaration name is a **major** blueprint accuracy issue (see below).

### `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` (chapter: `lem:acyclic_resolution_computes_derived`)
- **Lean target exists**: NO
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**:
  - No match in `lean_local_search`. Blueprint correctly carries **no** `\leanok`. Status markers are accurate.
  - Blocked on the horseshoe (`InjectiveResolution.ofShortExact`) and `rightDerivedShiftIsoOfAcyclic` (TARGET 1 and TARGET 2).

---

## Red flags

### False `\leanok` markers (must-fix)

- **`lem:injective_resolution_of_ses` statement block**: `\begin{lemma}\leanok` (blueprint line 190) — the named Lean declaration `CategoryTheory.InjectiveResolution.ofShortExact` is an `Unknown constant`. The marker is false.
- **`lem:injective_resolution_of_ses` proof block**: `\leanok` at blueprint line 217 — same root cause. The proof cannot be closed when the statement doesn't exist.

Root cause: the `/-! ... -/` strategy comment (Lean file lines 197–347) contains a code-fence with a suggested output type:
```
def InjectiveResolution.ofShortExact {A B C : 𝒜} ...
```
The Lean LSP incorrectly treats this backtick-fenced example as an elaborated declaration. `sync_leanok` uses the same LSP search and sets `\leanok` when it believes the declaration exists.

**Fix required this iteration**: (a) The code-fence inside the `/-! ... -/` strategy comment must be reformatted so the LSP does not parse it as a real declaration (e.g., use prose instead of a code fence, or enclose in a `-- `comment). (b) The `\leanok` markers on `lem:injective_resolution_of_ses` (statement and proof blocks) must be removed. (c) `sync_leanok` should be verified to cross-check its LSP result against `lean_verify` before setting `\leanok`.

### No other red flags in the Lean file
- No `:= sorry` anywhere in the file (all 5 new declarations are fully proved).
- No `axiom` declarations.
- All 5 verified declarations use only standard Lean/Mathlib axioms: `[propext, Classical.choice, Quot.sound]`.
- No excuse-comments (`-- temporary`, `-- placeholder`, `-- wrong but`).
- The status comment block explicitly identifies remaining work; this is accurate progress documentation, not excuse-commenting.

---

## Unreferenced declarations (informational)

The following 5 declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Kind | Notes |
|---|---|---|
| `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` | `lemma` | Kills acyclic middle-term homology; used as sub-step in `lem:acyclic_dimension_shift` proof sketch ("Transport `Hⁿ(G(I_J))` to `(Rⁿ G)(J)` via `isoRightDerivedObj`"). Acceptable as helper. |
| `shortExact_of_degreewise_splitting` | `lemma` | Degreewise-split → complex-level `ShortExact`; sub-step in the dimension-shift proof. Acceptable as helper. |
| `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` | `lemma` | Same as above, after applying `G`. Acceptable as helper. |
| **`Functor.rightDerivedShiftIsoOfSplitResolutionSES`** | `noncomputable def` | **Substantive.** Implements the core of TARGET 2 at the resolution level; not a small helper. The blueprint's `\lean{rightDerivedShiftIsoOfAcyclic}` points to a non-existent object-level wrapper. This declaration does the main dimension-shift work. Deserves a `\lean{}` hint. |
| **`mono_biprod_lift_factorThru_of_exact`** | `lemma` | **Substantive.** Named per-stage monomorphism for the horseshoe recursion. Mentioned explicitly in the horseshoe proof sketch ("the required lift exists because the relevant target summand is injective"). Deserves a `\lean{}` hint in the `lem:injective_resolution_of_ses` proof. |

Additionally, `Functor.IsRightAcyclic` (class) and `Functor.IsRightAcyclic.ofInjective` (instance) are in the file. The class has a `\lean{}` hint via `def:right_acyclic` (blueprint line 131). The instance is not explicitly tagged but is covered by `lem:right_derived_vanishes_injective`'s "in particular every injective object is right-G-acyclic" remark.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 named targets have a `\lean{...}` block. The 5 new declarations lack `\lean{}` references (2 are substantive enough to warrant them; 3 are acceptable helpers).

- **Proof-sketch depth**: **Adequate** for the declared route. The horseshoe proof (lines 215–239 of blueprint) and the dimension-shift proof (lines 306–377) both provide enough detail — the key steps (biproduct in each degree, injective lift for the off-diagonal differential, acyclicity forces exactness, degreewise splitness survives applying G) are all described. A prover could formalize from these sketches. The staircase induction for `lem:acyclic_resolution_computes_derived` (lines 455–528) is similarly complete.

- **Hint precision**: **Partially misaligned**. The `\lean{rightDerivedShiftIsoOfAcyclic}` hint for `lem:acyclic_dimension_shift` names an object-level declaration that does not yet exist; the actual Lean work is `rightDerivedShiftIsoOfSplitResolutionSES` (resolution-level). The two have different interfaces — the object-level version takes a SES of objects and a `[IsRightAcyclic G J]` instance; the resolution-level version takes explicit chain maps and degreewise splittings. Until the horseshoe is built, `rightDerivedShiftIsoOfAcyclic` cannot be defined, so the blueprint hint is pointing forward rather than wrong.

- **Generality**: **Matches need**. The blueprint sets up the argument at the level of generality the Lean file uses (abelian category, injective resolutions, arbitrary additive G).

- **Recommended chapter-side actions** (for blueprint-writing subagent):
  1. **must-fix**: Remove `\leanok` from both the statement block and proof block of `lem:injective_resolution_of_ses`. The horseshoe is not formalized.
  2. **must-fix**: Reformat the "Output type (suggested)" code fence in the Lean file's `/-! ... -/` strategy comment (lines ~282–286) so that `sync_leanok` / the LSP does not treat it as a real declaration. Suggested fix: replace the backtick code fence with plain indented prose or a `-- ` comment prefix, or add a `-- (not yet defined:)` guard above it. This is a Lean file fix, not a blueprint fix.
  3. **major**: Add `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES}` as a secondary hint in the `lem:acyclic_dimension_shift` proof block, noting it is the resolution-level precursor to `rightDerivedShiftIsoOfAcyclic`.
  4. **major**: Add `\lean{CategoryTheory.mono_biprod_lift_factorThru_of_exact}` in the `lem:injective_resolution_of_ses` proof block at the sentence "the universal lifting property of injectives produces the missing component."
  5. **minor**: Add `\lean{CategoryTheory.Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic}`, `\lean{CategoryTheory.shortExact_of_degreewise_splitting}`, `\lean{CategoryTheory.shortExact_map_mapHomologicalComplex_of_degreewise_splitting}` as inline hints in the `lem:acyclic_dimension_shift` proof.

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `\leanok` on `lem:injective_resolution_of_ses` statement block is false — declaration does not exist | **must-fix-this-iter** |
| 2 | `\leanok` on `lem:injective_resolution_of_ses` proof block is false — declaration does not exist | **must-fix-this-iter** |
| 3 | Code-fence in `/-! ... -/` strategy comment (line ~282) is parsed by the LSP as a phantom `InjectiveResolution.ofShortExact` declaration, corrupting `sync_leanok` | **must-fix-this-iter** |
| 4 | `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (substantive named declaration) has no `\lean{}` tag; the blueprint hint for TARGET 2 names a non-existent wrapper | **major** |
| 5 | `mono_biprod_lift_factorThru_of_exact` (named per-stage horseshoe lemma) has no `\lean{}` tag | **major** |
| 6 | `isZero_homology_mapHomologicalComplex_of_isRightAcyclic`, `shortExact_of_degreewise_splitting`, `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` — helpers with no `\lean{}` tag | **minor** |

**Overall verdict**: The 5 new sorry-free declarations are clean (standard axioms, no sorry, no red flags), but `\leanok` markers on `lem:injective_resolution_of_ses` are false positives caused by a code-fence inside a `/-! ... -/` strategy comment being misread by the LSP, and the blueprint's `\lean{rightDerivedShiftIsoOfAcyclic}` hint for TARGET 2 diverges from the actual Lean declaration name — 3 must-fix-this-iter findings, 2 major.
