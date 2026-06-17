# Lean ↔ Blueprint Check Report

## Slug
CechBridge

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

The chapter covers six files via `% archon:covers` directives. The audit scope is
restricted to `\lean{...}` targets that reside in (or should reside in)
`CechBridge.lean`, and to whether `CechBridge.lean`'s own declarations are covered.

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `\lem:cech_complex_hom_identification`)

- **Lean target exists**: **no** — this declaration does not appear in CechBridge.lean
  or anywhere in the project outline. The directive confirms: "CechBridge: target
  `cechComplex_hom_identification` NOT built (per-degree iso + naturality core built)."
- **Signature matches**: N/A (target absent)
- **Proof follows sketch**: N/A (target absent)
- **Notes**: The three-step assembly described in the chapter prose was decomposed
  this iteration into three intermediate infrastructure declarations
  (`homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`) plus three private
  helpers. The final assembly step — combining the per-degree isos into a full
  cochain-complex isomorphism via `HomologicalComplex.Hom.isoOfComponents` — is absent.
  The file contains an explicit handoff comment (lines 196–207) explaining the gap was
  a concurrent-upstream-compile blocker, not a dead end. This is a known gap per the
  directive; classified **major** (not must-fix because it is an acknowledged
  decomposition handoff, not a wrong placeholder proof).

### `\lean{AlgebraicGeometry.freeYonedaHomEquiv}`, `\lean{AlgebraicGeometry.freeYonedaHomAddEquiv}`, `\lean{AlgebraicGeometry.freeYonedaHomEquiv_apply}` (chapter: `\lem:cech_complex_hom_identification`)

- **Lean target exists**: These live in `PresheafCech.lean`, not `CechBridge.lean`.
  Out of scope for this per-file audit.
- **Notes**: CechBridge.lean correctly imports and uses `freeYonedaHomAddEquiv` at
  lines 146 and 182–193, consistent with the blueprint's description of these
  as the "per-index free–Yoneda section identification."

---

## Red flags

### Placeholder / suspect bodies

None. All three public declarations have substantive, non-sorry bodies. The
`lean_verify` check confirms only standard Lean/Mathlib axioms:
`{propext, Classical.choice, Quot.sound}` — for all of
`homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`.

### Excuse-comments

**Lines 196–207** — Large comment block beginning "Remaining assembly (handed off — see
task_results)" ends with: "This was held back this iteration only because the upstream
`FreePresheafComplex.lean` was being edited concurrently and would not compile."

Assessment: this is a prover hand-off note explaining an iteration-level engineering
constraint, not an excuse for wrong or placeholder code. The code present in the file
is correct infrastructure. The comment does not attach to any declaration body; it
annotates the gap between the infrastructure built and the assembly not yet done.
Classified as **minor** (informational, not misleading — the existing code is sound).

### Axioms / Classical.choice on non-trivial claims

None. All declarations use only `{propext, Classical.choice, Quot.sound}`, which is
the standard Lean/Mathlib baseline.

### Diagnostics

LSP reports **2 style linter warnings** (not errors) in `freeYonedaHomAddEquiv_naturality`
(private helper, lines 185 and 187): `show` used where `change` is recommended.
No compilation errors. No failed dependencies.

---

## Unreferenced declarations (informational)

The following declarations in CechBridge.lean have **no corresponding `\lean{...}` reference** in the blueprint:

| Declaration | Kind | Visibility | Should be in blueprint? |
|---|---|---|---|
| `AlgebraicGeometry.homCechCosimplicial` | def | public | **Yes** — substantive infrastructure |
| `AlgebraicGeometry.homCechComplex` | def | public | **Yes** — substantive infrastructure |
| `AlgebraicGeometry.homCechSectionIsoApp` | def | public | **Yes** — substantive, the degreewise core |
| `pi_mapIso_hom_eq` | lemma | private | No — trivial helper |
| `homCechSectionIsoApp_hom_π` | lemma | private | No — characterisation lemma, helper |
| `freeYonedaHomAddEquiv_naturality` | lemma | private | Borderline — powers naturality of the iso; flagged below |

`homCechCosimplicial`, `homCechComplex`, and `homCechSectionIsoApp` are the per-degree
infrastructure for `cechComplex_hom_identification`. They are substantive enough to
warrant individual `\lean{...}` annotations; their absence from the chapter is a
blueprint coverage gap (see §Blueprint adequacy).

`freeYonedaHomAddEquiv_naturality` (private, lines 179–194) — states: precomposition
with `freeYoneda.map h` corresponds to `F.presheaf.map h.op` under
`freeYonedaHomAddEquiv`. This is the naturality square that powers the cosimplicial
natural isomorphism; the blueprint's proof sketch for `lem:cech_complex_hom_identification`
says "the per-degree isos ... commute with the differentials" without naming this as a
lemma. Acceptable as a private helper, but worth promoting to blueprint prose.

---

## Blueprint adequacy for this file

**Coverage**: 0 / 3 public substantive declarations in CechBridge.lean have a
corresponding `\lean{...}` block. The chapter's `\lean{...}` list for
`lem:cech_complex_hom_identification` names `cechComplex_hom_identification` (absent),
plus three PresheafCech helpers; it does not name `homCechCosimplicial`,
`homCechComplex`, or `homCechSectionIsoApp`.

**Proof-sketch depth**: **under-specified** for the three intermediate declarations.
The chapter's proof sketch for `lem:cech_complex_hom_identification` is adequate at the
high level (three steps: per-degree iso, differential intertwining, assembly via
`isoOfComponents`), but it gives no guidance on the intermediate objects. A prover
formalising from the blueprint alone would not know to define `homCechCosimplicial` as
`(cechFreeSimplicial 𝒰).rightOp ⋙ preadditiveYoneda.obj F` or to use
`opCoproductIsoProduct` and `piComparison` for the per-degree iso. The prover strategy
comment embedded in the Lean file itself (lines 51–94) provides this detail; it is
richer than the corresponding blueprint proof block.

**Hint precision**: **loose**. The `\lean{AlgebraicGeometry.cechComplex_hom_identification,...}`
hint is correct in naming the final target but omits the intermediate declarations that
the prover actually needed to build first. The blueprint-guidance gap between "here is
the target name" and "here is the internal structure" is what caused the assembly to be
deferred: the prover had to invent the decomposition without blueprint support.

**Generality**: **matches need** — no under- or over-generalisation found.

**Recommended chapter-side actions**:
1. Add a separate definition block (or expand `lem:cech_complex_hom_identification`)
   naming `homCechCosimplicial`, `homCechComplex`, and `homCechSectionIsoApp` with
   `\lean{}` hints and one-sentence descriptions.
2. Promote `freeYonedaHomAddEquiv_naturality` to the blueprint proof sketch as the
   named naturality square underpinning Step 2 of the identification.
3. Once `cechComplex_hom_identification` is built, add it to the `\lean{}` list and
   update `\leanok` accordingly (via the deterministic `sync_leanok` pass).
4. Optionally move the prover strategy comment (lines 51–94 of CechBridge.lean) into
   the blueprint `\begin{proof}` block for `lem:cech_complex_hom_identification` so the
   prose detail lives in the canonical location rather than embedded in the Lean file.

---

## Severity summary

| Finding | Severity |
|---|---|
| Named target `cechComplex_hom_identification` absent from CechBridge.lean | **major** |
| 3 substantive public declarations lack `\lean{...}` coverage in blueprint | **major** |
| Blueprint proof sketch under-specified (no guidance on intermediate structure) | **major** |
| Handoff comment at lines 196–207 (informational, not misleading) | **minor** |
| Style linter warnings (lines 185, 187; `show` vs `change`) | **minor** |

No **must-fix-this-iter** findings: no sorry bodies, no wrong signatures, no axioms
beyond the Lean/Mathlib baseline, no excuse-comments on present code, no weakened
definitions.

**Overall verdict**: CechBridge.lean is axiom-clean infrastructure (3 public
declarations, standard axioms only, no sorries) that correctly builds the per-degree
and naturality core of the Čech hom-identification; the named assembly target
`cechComplex_hom_identification` is absent due to a known iteration-level handoff, and
the blueprint lacks `\lean{...}` coverage for the 3 present substantive declarations —
both gaps are **major** and should be addressed in the next iteration.
