# Report: blueprint-clean — purify iter-041 B3/B4 planner edits

**Status:** DONE  
**File touched:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Changes made

### B3b — `lem:restrict_over_compat`

**Statement (line ~4193):** Removed the parenthetical `where the \(\widetilde{(-)} / \operatorname{fromTilde\Gamma}\) machinery lives` — this was an implementation note referencing a Lean-specific name (`fromTildeGamma`). The surrounding sentence remains mathematically complete.

**Proof, Step B3a (line ~4223):** Replaced `\operatorname{Scheme.Modules.restrictFunctor}` (a qualified Lean API name) with `the module-restriction functor along an open immersion`. Mathematical content preserved: the comparison ring-sheaf morphisms use the same open-immersion structure-sheaf isomorphism datum as the module-restriction functor.

**Proof, Remark B3c (line ~4246):** Replaced `the isomorphism \(\operatorname{basicOpenIsoSpecAway} g\)` with `the canonical identification \(D(g) \cong \operatorname{Spec} R_g\)`. Mathematically equivalent; avoids the Lean identifier.

### B4 — `lem:presentation_modulesRestrictBasicOpen`

**Proof (lines ~4284–4290):** Stripped four Lean API identifiers from the final paragraph:
- `\operatorname{restrictFunctor}(\operatorname{basicOpenIsoSpecAway} g)^{-1}` → replaced with "restriction along this isomorphism" (the isomorphism is introduced in the same sentence as the canonical identification).
- `\operatorname{restrictBasicOpenUnitIso} g` (intermediate named construction) → folded into "carries the structure-sheaf unit … to the unit of Spec R_g — this unit compatibility holds because the identification is an isomorphism of schemes."
- `\operatorname{restrictFunctorIsoPullback}` — stripped (pure plumbing, not needed for understanding).
- `\operatorname{pullbackObjUnitToUnit}` and `\operatorname{pullbackObjUnitToUnit\_isIso\_basicOpen}` — stripped (pure plumbing); the mathematical content ("isomorphism because the identification is an isomorphism of schemes") is retained in the prose.

---

## Invariants confirmed

- `\lean{}` and `\uses{}` targets: **untouched** (including `AlgebraicGeometry.pullbackObjUnitToUnit_isIso_basicOpen` in `\lean{}`).
- `\leanok` markers: **untouched**.
- The keystone `lem:qcoh_section_isLocalizedModule` block: **untouched**.
- No SOURCE QUOTE inserted (these blocks are project-bespoke categorical plumbing with no external citation needed; absence is acceptable per the directive).

---

## Residual Lean identifiers in the B3b/B4 range

A final grep over lines 4169–4300 found only one hit:
```
4262:    AlgebraicGeometry.pullbackObjUnitToUnit_isIso_basicOpen}
```
This is inside `\lean{…}` — intentionally kept per directive ("Do NOT alter `\lean{}` targets").
