# Blueprint Review Report

## Slug
ts219fp

## Iteration
219

## Gate chapter audit: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

This is a scoped fast-path re-review. The gate verdict below covers only
`Picard_TensorObjSubstrate.tex`; all other chapters are audited for
cross-chapter consistency but their per-chapter verdicts are informational.

---

### Check 1 — `lem:tensorobj_inverse_invertible` proof (was MUST-FIX)

**Resolved correctly.** The proof now opens with an explicit
**Infrastructure-blocked** heading (line 1617 of the chapter) stating:
"This statement is *not* realizable with the 𝒪_X-module infrastructure
presently available: its construction depends on a *sheaf internal hom of
𝒪_X-modules* ℋom_{𝒪_X}(L, 𝒪_X), an object that does not yet exist at the
presheaf, sheaf, or general-categorical level." The proof then records the
intended mathematical route (three steps) conditional on
`sec:tensorobj_dual_infra`, and explicitly cross-references
`lem:internal_hom_eval` and `lem:dual_isLocallyTrivial` as the new
infrastructure that discharges it. The `\uses{}` on the proof block has been
updated to include `lem:internal_hom_eval` and `lem:dual_isLocallyTrivial`
(both now defined later in the same file). The dual object `L⁻¹` is no longer
claimed to be constructible; the proof honestly marks itself as a placeholder
until the infrastructure lands.

**Mathematical route recorded:** Step 1 (L⁻¹ locally trivial via internal-hom
restriction-compatibility + trivialisation), Step 2 (contraction is a local
isomorphism via `lem:tensorobj_restrict_iso` + `lem:tensorobj_unit_iso`), Step
3 (local→global via `lem:tensorobj_restrict_iso`). All three steps are correct
modulo the missing object.

---

### Check 2 — `lem:tensorobj_assoc_iso` proof note (was MAJOR)

**Resolved correctly.** The proof now opens with:
"**Status (route mismatch, deferred).** The *current* realization of this
associator uses the route-(d) whiskering composite … through
`lem:islocallyinjective_whisker_of_W` — whose left-whiskering component is
itself unproved — it transitively depends on an open proof obligation and is
therefore *not* axiom-clean. The gluing route described below is the *intended*
obligation-free realization, but discharging it requires *morphism-level descent
for SheafOfModules* … That is the same descent-infrastructure family the
⊗-inverse needs (`sec:tensorobj_dual_infra`); accordingly, the associator
re-route *and* the deletion of the vestigial whiskering/stalk apparatus are
deferred jointly with the dual block."

This is accurate: the current Lean pin is not axiom-clean (it routes through an
unproved whiskering obligation), the intended gluing route is correctly stated,
and the deferral reason (needs morphism-level descent, jointly with the dual
block) is accurate. The `\leanok` on the statement block (meaning a
sorry-bearing Lean declaration exists) is consistent with Archon's marker
semantics. The proof block correctly has no `\leanok`.

---

### Check 3 — Superseded-block wording (was MINOR)

**Resolved correctly.** None of the six superseded blocks contain "removed in
iter-218" language. Each carries the comment:
`% SUPERSEDED route (route-(d)/(e) whiskering/stalk machinery); pending
deletion once the assoc re-route (morphism-level descent) lands. Declaration
still present and still backing the current 'tensorObj_assoc_iso' proof.`
The declarations remain present, their wording is honest, and there is no false
claim about prior removal.

---

### Check 4 — New `\section{...}\label{sec:tensorobj_dual_infra}`

#### (a) Mathematical correctness

**`def:presheaf_internal_hom`** — Slice formula
`ℋom(M,N)(U) := ModuleCat.of (R(U)) (M|_U → N|_U)` is the standard internal
hom of sheaves of modules (Stacks tag 01CM), correct. Restriction maps: a
morphism `M|_U → N|_U` restricts to `M|_V → N|_V` for V⊆U, which is
covariant. Contravariance issue for the naive `U↦Hom_{R(U)}(M(U), N(U))`
correctly identified and the slice remedy correctly stated.

**`def:presheaf_dual`** — `M^∨ := ℋom(M, R)` is the standard linear dual.
Specialisation of `def:presheaf_internal_hom` to N = R (the unit presheaf).
Correct.

**`lem:internal_hom_eval`** — Evaluation/contraction
`ev_M : M ⊗_R M^∨ → R`, `s ⊗ φ ↦ φ(s)`. Described as the counit of the
tensor-hom adjunction specialised to R. The proof correctly assembles it
open-by-open (sectionwise bilinear map, then naturality in restriction).
Correct.

**`lem:internal_hom_isSheaf`** — Sheaf condition for `ℋom(M, N)`: a family of
morphisms `M|_{U_i} → N|_{U_i}` agreeing on overlaps glues uniquely to
`M|_U → N|_U` because N is a sheaf (section-wise gluing). Correctly stated and
proved. Specialises to the sheaf-level dual `dual M := ℋom(M, O_X)`. Correct.

**`lem:dual_isLocallyTrivial`** — Dual of a line bundle is a line bundle. Proof:
internal hom commutes with open-immersion restriction (slice formula makes this
definitional), so `(dual L)|_U ≅ ℋom(O_U, O_U) ≅ O_U` under the
trivialisation. Correct; this is Stacks tag 01CR item 2.

**`rem:dual_discharges_inverse`** — Correctly explains how the five sub-steps
close `lem:tensorobj_inverse_invertible`: take `L⁻¹ := dual L`
(`lem:internal_hom_isSheaf`), note it is a line bundle (`lem:dual_isLocallyTrivial`),
and show the descended evaluation is a global isomorphism by the local→global
argument via `lem:tensorobj_restrict_iso` and `lem:tensorobj_unit_iso`. Correct.

**`rem:dual_via_stack`** — Alternative object-level descent route (effective
descent for sheaves of modules). Correctly characterised as a fallback, heavier
build. Correct.

#### (b) Detail sufficient for prover on `def:presheaf_internal_hom`

Yes. The block gives:
- Exact object map formula: `ℋom(M,N)(U) = ModuleCat.of (R(U)) (M|_U → N|_U)`.
- Exact morphism map (restriction): further restriction of a morphism of
  restricted modules, covariant in V⊆U.
- Explanation of why this is forced (contravariance of pointwise formula).
- `\lean{PresheafOfModules.internalHom}` — the expected Lean target.
- `\uses{def:scheme_modules_tensorobj}` — resolves.

A prover needs to: (1) define the object map, (2) define restriction maps (send
`φ : M|_U → N|_U` to `φ|_V : M|_V → N|_V`), (3) check functoriality
(identity and composition). All of (1)–(2) are explicit; (3) is implicit but
standard. Sufficient.

#### (c) Well-formedness of `\lean{}`/`\uses{}`/`\label{}`

All labels in the section:
- `def:presheaf_internal_hom` — defined ✓
- `def:presheaf_dual` — uses `def:presheaf_internal_hom` (defined above it) ✓
- `lem:internal_hom_eval` — uses `def:presheaf_dual`, `def:scheme_modules_tensorobj` ✓
- `lem:internal_hom_isSheaf` — uses `def:presheaf_dual`, `lem:internal_hom_eval` ✓
- `lem:dual_isLocallyTrivial` — uses `lem:internal_hom_isSheaf`, `lem:tensorobj_restrict_iso` ✓
- `rem:dual_discharges_inverse` — uses `lem:tensorobj_inverse_invertible`, `lem:dual_isLocallyTrivial`, `lem:internal_hom_eval`, `lem:tensorobj_restrict_iso`, `lem:tensorobj_unit_iso` ✓

`\lean{}` hints: `PresheafOfModules.internalHom`, `PresheafOfModules.dual`,
`PresheafOfModules.internalHomEval`, `AlgebraicGeometry.Scheme.Modules.dual`,
`AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial` — all are new
project-side declarations following established naming conventions. None
conflicts with existing Mathlib names.

Global `\uses{}` cross-check: a Python scan of all 33 chapters found only 2
"undefined" label references across the entire blueprint, and both are `...`
ellipsis placeholders in comment lines in `RiemannRoch_H1Vanishing.tex` — not
actual broken references. All 685 real labels resolve.

#### (d) Contravariance explanation

The contravariance issue is explained clearly in two places:
1. The section introduction (preceding `def:presheaf_internal_hom`): "The naive
   rule `U ↦ Hom_{R(U)}(M(U), N(U))` is *contravariant* in the restriction maps
   of M … The remedy is the *slice* formula `U ↦ (M|_U → N|_U)`."
2. The definition itself: "The slice formula is forced by contravariance: the
   pointwise rule `U ↦ Hom_{R(U)}(M(U), N(U))` varies *against* the restriction
   maps of M and so is not a covariant presheaf, whereas the module of morphisms
   of *restricted* objects `M|_U → N|_U` restricts covariantly."

Sufficient to guide a Lean construction; the prover is told exactly why the
pointwise formula fails and what the correct formula is.

#### Citation discipline for the new section

| Block | SOURCE pointer | (read from …) | SOURCE QUOTE | QUOTE verbatim | Visible \textit{Source:…} |
|---|---|---|---|---|---|
| `def:presheaf_internal_hom` | [Stacks], "Modules on Ringed Spaces", §Internal Hom, tag area 01CM | `references/stacks-modules.tex, L3500–L3524` | ✓ | ✓ (French is not the language; Stacks is in English; quote is verbatim English) | ✓ |
| `def:presheaf_dual` | no SOURCE (Archon-original specialisation) | n/a | n/a | n/a | n/a |
| `lem:internal_hom_eval` | [Stacks], same §, tag area 01CM | `references/stacks-modules.tex, L3517–L3524` | ✓ | ✓ | ✓ |
| `lem:internal_hom_isSheaf` | [Stacks], same §, tag area 01CM | `references/stacks-modules.tex, L3502–L3514` | ✓ | ✓ | ✓ |
| `lem:dual_isLocallyTrivial` | [Stacks], Tag 01CR, Lemma lemma-constructions-invertible item 2 | `references/stacks-modules.tex, L4200–L4213` | ✓ | ✓ | ✓ |

`references/stacks-modules.tex` is an established reference file already cited
throughout the chapter; no fabrication concern.

---

## Per-chapter (gate chapter)

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Informational** — `lem:dual_isLocallyTrivial` cites `\uses{lem:tensorobj_restrict_iso}` for
    the internal-hom restriction-compatibility invoked in its proof, but the actual
    lemma used is the "dual analogue" of `lem:tensorobj_restrict_iso` for the internal
    hom — a consequence of the slice definition, arguably definitional. A separate
    `lem:internal_hom_restrict_iso` lemma would be cleaner. Does NOT block the prover
    on `def:presheaf_internal_hom`.
  - The proof of `lem:tensorobj_assoc_iso` carries `\leanok` on the statement but
    not on the proof block, which is correct: the Lean declaration exists (possibly
    sorry-bearing via the whiskering route) but the proof is not axiom-clean. The
    "route mismatch, deferred" note is accurate and consistent with the marker
    semantics.

---

## Cross-chapter notes

- `AlgebraicJacobian_Cotangent_GrpObj.tex` is a pointer chapter with 0 `\lean{}`
  blocks — consistent with prior reviews; mathematical content lives in
  `RigidityKbar.tex`. Not a concern.
- New labels `def:presheaf_internal_hom`, `def:presheaf_dual`,
  `lem:internal_hom_eval`, `lem:internal_hom_isSheaf`, `lem:dual_isLocallyTrivial`
  are correctly scoped to `Picard_TensorObjSubstrate.tex` and not mis-referenced
  from other chapters.
- No cross-chapter `\uses{}` breakage detected (Python scan, 685 labels, 308 uses
  calls).

---

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix-this-iter findings for `Picard_TensorObjSubstrate.tex`.

One informational note on `lem:dual_isLocallyTrivial` (see Per-chapter notes above); does not block prover dispatch.

---

## Overall verdict

`Picard_TensorObjSubstrate.tex` is **complete: true, correct: true** with no
must-fix findings. The three iter-218 MUST-FIX / MAJOR items are all resolved
correctly. The new `sec:tensorobj_dual_infra` section is mathematically sound,
well-cited, and sufficiently detailed to dispatch a prover on `def:presheaf_internal_hom`
(the first sub-step, `\lean{PresheafOfModules.internalHom}`) this iteration.
**Gate cleared; prover may be dispatched on `def:presheaf_internal_hom`.**
