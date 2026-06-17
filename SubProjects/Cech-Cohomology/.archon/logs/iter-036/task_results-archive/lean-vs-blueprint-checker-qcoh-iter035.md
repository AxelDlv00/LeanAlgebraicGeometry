# Lean ↔ Blueprint Check Report

## Slug
qcoh-iter035

## Iteration
035

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: `lem:modules_restrict_basicOpen`, `lem:tilde_restrict_basicOpen`,
  `lem:presentation_restrict_basicOpen`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.modulesRestrictBasicOpen, AlgebraicGeometry.modulesRestrictBasicOpenIso}` (chapter: `lem:modules_restrict_basicOpen`)

- **Lean targets exist**: yes — both `modulesRestrictBasicOpen` (line 38) and `modulesRestrictBasicOpenIso` (line 47) are present.
- **Signature matches**: yes.
  - Blueprint: "an object F_{(f)} ∈ (Spec R_f).Modules together with an isomorphism F|_{D(f)} ≅ F_{(f)}."
  - Lean: `modulesRestrictBasicOpen f F : (Spec (CommRingCat.of (Localization.Away f))).Modules` is F_{(f)} (the iterated restriction); `modulesRestrictBasicOpenIso f F : modulesRestrictBasicOpen f F ≅ (Scheme.Modules.pullback (specAwayToSpec f)).obj F` is the comparison iso.
  - Both sides of the iso live in `(Spec R_f).Modules`. The comparison iso identifies the concretely-built double-restriction with the abstract pullback formulation — this is exactly F|_{D(f)} ≅ F_{(f)} in the blueprint's notation.
- **Proof follows sketch**: yes.
  - Blueprint proof: "Pulling the restricted module F|_{D(f)} back along the inverse of the iso D(f) ≅ Spec R_f transports it; the unit of the transport supplies the comparison iso."
  - Lean definition body: `(F.restrict (specBasicOpen f).ι).restrict (basicOpenIsoSpecAway f).inv` — restrict to D(f) then restrict along the inverse iso; this matches exactly.
  - Lean iso body: `((Scheme.Modules.restrictFunctorComp ...).app F).symm ≪≫ (Scheme.Modules.restrictFunctorIsoPullback ...).app F` — merges the two restrictions via `restrictFunctorComp`, then uses `restrictFunctorIsoPullback` for the pullback identification; aligns with the blueprint's "unit of the transport" step.
- **Axiom check**: both `modulesRestrictBasicOpen` and `modulesRestrictBasicOpenIso` verify clean — only `propext`, `Classical.choice`, `Quot.sound`.
- **notes**:
  - No `\leanok` appears in the statement or proof block in the blueprint. Root cause: `QcohRestrictBasicOpen.lean` is not yet imported by `AlgebraicJacobian.lean` (see Major findings), so `sync_leanok` cannot find these declarations. Expected behavior given the known pending "Wire root import" action.
  - Blueprint claims functoriality ("this assignment is functorial in F") but no Lean `NatTrans` or `Functor` iso formalizes it — only pointwise isos. Acceptable at this stage; the individual isos are sufficient for downstream use.

### `\lean{AlgebraicGeometry.tilde_restrict_basicOpen}` (chapter: `lem:tilde_restrict_basicOpen`)

- **Lean target exists**: no — declaration absent from the Lean file (correctly so; prover left it absent, blocked on missing Mathlib tilde base-change compatibility).
- **Signature matches**: N/A (absent).
- **Proof follows sketch**: N/A.
- **notes**: No `\leanok` in the blueprint block — correct. Blueprint prose is honestly marked as unformalized (no `\leanok`, no false `\mathlibok`).

### `\lean{AlgebraicGeometry.presentation_restrict_basicOpen}` (chapter: `lem:presentation_restrict_basicOpen`)

- **Lean target exists**: no — declaration absent from the Lean file (correctly so; blocked transitively on `tilde_restrict_basicOpen`).
- **Signature matches**: N/A (absent).
- **Proof follows sketch**: N/A.
- **notes**: No `\leanok` in the blueprint block — correct. Blueprint prose is honestly marked as unformalized.

---

## Red flags

None. No `sorry`, no placeholder bodies, no excuse-comments, no project-local axioms introduced.

---

## Unreferenced declarations (informational)

Three declarations in the Lean file have NO corresponding `\lean{...}` blueprint block:

| Declaration | Type | Status |
|---|---|---|
| `AlgebraicGeometry.specBasicOpen` (line 25) | `abbrev` | Pure abbreviation for `PrimeSpectrum.basicOpen f` as an `Opens`. Reasonable plumbing helper. |
| `AlgebraicGeometry.specAwayToSpec` (line 29) | `noncomputable abbrev` | Assembles `basicOpenIsoSpecAway f .inv ≫ (specBasicOpen f).ι` — the geometric localisation map. Helper used by `modulesRestrictBasicOpenIso` and `specAwayToSpec_eq`. |
| `AlgebraicGeometry.specAwayToSpec_eq` (line 56) | `theorem` | Identifies `specAwayToSpec f` with `Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away f)))`. Axiom-clean. Bridge lemma between geometric and algebraic descriptions. |

All three are substantive helpers directly supporting the two named targets. Their absence from the blueprint is **coverage debt** — a blueprint-writing subagent should add a short `\lean{...}` reference block (possibly as a remark or helper lemma) so the DAG accounts for them.

---

## Blueprint adequacy for this file

- **Coverage**: 2/5 Lean declarations have a corresponding `\lean{...}` block (the two named targets share one block under `lem:modules_restrict_basicOpen`). The 3 unreferenced declarations are all real substantive helpers, not trivial glue — they are DAG-invisible.
- **Proof-sketch depth**: adequate for the two named targets. The blueprint's proof of `lem:modules_restrict_basicOpen` describes the double-restriction construction and identifies the comparison iso as the "unit of the transport" — this is precisely what the Lean proof implements via `restrictFunctorComp` and `restrictFunctorIsoPullback`.
- **Hint precision**: precise — `\lean{AlgebraicGeometry.modulesRestrictBasicOpen, AlgebraicGeometry.modulesRestrictBasicOpenIso}` names both declarations and pinned the prover to the right Mathlib predicates (`Scheme.Modules`, `restrict`, `basicOpenIsoSpecAway`).
- **Generality**: matches need — the blueprint states the lemma for a general `(Spec R).Modules` object, and the Lean is parameterized by an arbitrary `F : (Spec R).Modules`.
- **Recommended chapter-side actions**:
  - Add `% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` to the header covers list (see Structural gap below).
  - Add a helper remark block with `\lean{AlgebraicGeometry.specBasicOpen, AlgebraicGeometry.specAwayToSpec, AlgebraicGeometry.specAwayToSpec_eq}` to cover the three unreferenced declarations.
  - Optionally sharpen the "functorial in F" claim to reference that Lean provides only pointwise isos, not a natural transformation.

---

## Structural coverage gap (major)

### Missing `% archon:covers` entry

The chapter header lists 10 covered files (lines 3–12):
```
% archon:covers AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
% archon:covers AlgebraicJacobian/Cohomology/CechAcyclic.lean
...
% archon:covers AlgebraicJacobian/Cohomology/QcohTildeSections.lean
```
`AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` is **absent**. The review agent should add the entry.

### Missing root import (major — blocks sync_leanok)

`AlgebraicJacobian.lean` (the root file) does NOT import `AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen`. Consequently:
- `sync_leanok` cannot find `modulesRestrictBasicOpen` / `modulesRestrictBasicOpenIso` in the compiled module graph, so the `\leanok` marker for `lem:modules_restrict_basicOpen` has not been set despite both declarations being axiom-clean.
- The blueprint DAG treats these declarations as non-existent, understating completeness.
- Downstream files that will need `QcohRestrictBasicOpen` (specifically `QcohTildeSections` for the full 01I8 assembly) cannot import it transitively.

The "Wire root import next iter" action from memory should be promoted to a concrete plan-phase task.

---

## Severity summary

| Finding | Severity |
|---|---|
| Missing root import (`AlgebraicJacobian.lean` does not import `QcohRestrictBasicOpen`) | **major** |
| Missing `% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` | **major** |
| Three helper decls (`specBasicOpen`, `specAwayToSpec`, `specAwayToSpec_eq`) unreferenced in blueprint | **major** |
| Functoriality ("functorial in F") not formalized as a `NatTrans`/`Functor` iso in Lean | **minor** |
| No `\leanok` on `lem:modules_restrict_basicOpen` (consequence of missing root import; `sync_leanok` can't find declarations) | minor (expected; resolves automatically once root import is wired) |

**No must-fix-this-iter findings.** Both named targets (`modulesRestrictBasicOpen`, `modulesRestrictBasicOpenIso`) faithfully realize the blueprint lemma with axiom-clean proofs; `tilde_restrict_basicOpen` and `presentation_restrict_basicOpen` are correctly absent and honestly unmarked.

**Overall verdict**: The two P1a named targets are correctly and faithfully formalized; no semantic issues. The blocking gaps are structural (missing root import, missing covers entry, three unreferenced helpers) — none of which corrupt the Lean content itself but all of which must be resolved before `sync_leanok` can propagate the `\leanok` markers and before downstream 01I8 assembly can proceed.
