# Blueprint Clean Report — bc257

**Archon iteration:** 257
**Subagent:** blueprint-clean

---

## Summary

Purity pass completed on all three designated chapters. Source quotes verified against reference files. Lean leakage cleaned from two chapters. One project-history phrase removed.

---

## Chapter 1: `Picard_TensorObjSubstrate.tex`

### Issues found and fixed

**1. Project-history reference in rendered text (line 2682 pre-edit).**
The D2′ summary bullet contained `\emph{closed iter-250}` in rendered prose:
```
(\cref{lem:pullback_tensor_iso_unit}, \emph{closed iter-250}).
```
Fixed to:
```
(\cref{lem:pullback_tensor_iso_unit}).
```

### D3′ `lem:pullback_tensor_map_basechange` proof — status

The proof of `lem:pullback_tensor_map_basechange` (lines ~3906–3991) was reviewed in full. All Lean identifiers (`Functor.OplaxMonoidal.comp_δ`, `PresheafOfModules.pullbackComp`, `conjugateEquiv_pullbackComp_inv`, etc.) appear exclusively in `\mathtt{…}` inline math, serving as named-ingredient references per the allowance in the directive. No tactic blocks, `:= by …` syntax, or unacceptable Lean leakage detected.

### `lem:dual_restrict_iso` leg-(A) `sliceDualTransport` paragraph — status

The `sliceDualTransport` paragraph (lines ~5658–5724) uses `\mathtt{Functor.FullyFaithful.homEquiv}`, `\mathtt{eqToHom}`, `\mathtt{Subsingleton.elim}`, `\mathtt{PresheafOfModules.isoMk}` as named ingredient references throughout. These are all wrapped in `\mathtt{…}` math mode and describe the mathematical construction rather than encoding tactics. No tactic blocks or `:= by …` syntax present. **No changes required.**

### Remaining project-history comments

Lines 2158–2159, 2374, 4683, 5252–5257 contain iter-number references but all are inside `%`-prefixed LaTeX comments and do not appear in rendered output. **Left untouched** per convention (comments are for the formalization team).

---

## Chapter 2: `Picard_LineBundleCoherence.tex`

### Issues found and fixed

**1. Lean implementation prose in proof of `lem:lbc_chart_presentation`.**
Second proof paragraph began "Concretely, in Lean the chart presentation is built by…" and included phrases "inferred automatically by typeclass resolution", "No separate finiteness declaration … is needed", "the `IsFinite` datum rides along as an instance". These describe Lean proof strategy, not mathematics.

Replaced with:
> The chart presentation is obtained by transporting the canonical finite presentation of `unit(U_i).ringCatSheaf` along the isomorphism $e_i$, using `SheafOfModules.Presentation.ofIsIso`. This construction carries any finite presentation of a module to a finite presentation of any isomorphic module, so the transported presentation of $M|_{U_i}$ is again finite.

**2. Lean leakage in proof of `thm:lbc_isFinitePresentation`.**
Passage contained "the `IsFinite` datum is *not* supplied by hand: it is the automatic typeclass instance riding along…discharged by inference rather than by a separate lemma. Feeding the resulting datum to `SheafOfModules.IsFinitePresentation.mk` — equivalently, the anonymous `⟨⟨…⟩⟩` constructor — gives…"

Cleaned: removed "not supplied by hand / automatic typeclass instance / discharged by inference" language and the anonymous constructor syntax. The revised text reads:
> Each such presentation is finite by Lemma [lbc_chart_presentation]; the assembled `QuasicoherentData` therefore satisfies `QuasicoherentData.IsFinitePresentation`, and the constructor `SheafOfModules.IsFinitePresentation.mk` yields `M.IsFinitePresentation`.

**3. Lean leakage in statement of `cor:lbc_isFiniteType`.**
"This is the named result. Quasi-coherence … follows automatically and needs no separate named theorem: it is supplied by the Mathlib instance…" removed "named result", "named theorem", "Mathlib instance" framing. Replaced with:
> Quasi-coherence (`M.IsQuasicoherent`) follows from finite presentation via `SheafOfModules.instIsQuasicoherentOfIsFinitePresentation`.

**4. Lean leakage in proof of `cor:lbc_isFiniteType`.**
"Quasi-coherence is not separately stated in the Lean type — it is available as the Mathlib instance…" Fixed to:
> Quasi-coherence is immediate from finite presentation by `SheafOfModules.instIsQuasicoherentOfIsFinitePresentation`.

**5. Meta-phrase in `cor:lbc_isFiniteType` proof.**
"this is the content of the named declaration" removed (the proof sentence is complete without it).

**6. Lean leakage in statement of `lem:lbc_rank_flat`.**
"the Lean type states only the iso itself, since Mathlib has no `SheafOfModules`-level rank or flatness predicate" and "not separately recorded in the type" replaced with mathematically accurate language: rank-one freeness and flatness are consequences of the iso but not separately abstracted.

**7. Lean leakage in proof of `lem:lbc_rank_flat`.**
"because there is no `SheafOfModules`-level locally free or flat predicate globally" replaced with the mathematical reason: "because rank-one freeness and flatness are local conditions."

### `\leanok` markers — verified untouched

Present on: `lem:lbc_trivializing_cover`, `lem:lbc_chart_presentation`, `thm:lbc_isFinitePresentation`, `cor:lbc_isFiniteType`, `lem:lbc_rank_flat`. All five preserved exactly as found.

---

## Chapter 3: `Cohomology_CechHigherDirectImage.tex` (NEW chapter)

### Source quote verification

All `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` blocks verified verbatim against `references/stacks-coherent.tex`:

| Block | Source location | Status |
|---|---|---|
| `def:cech_nerve` statement quote | stacks-coherent.tex lines 36–42 | ✓ verbatim |
| `def:cech_complex` statement quote | stacks-coherent.tex lines 59–79 | ✓ verbatim |
| `lem:cech_acyclic_affine` lemma quote (Tag 02KG) | stacks-coherent.tex lines 46–51 | ✓ verbatim |
| `lem:cech_acyclic_affine` slogan+statement quote | stacks-coherent.tex lines 147–154 | ✓ verbatim (slogan text included, markup stripped) |
| `lem:cech_acyclic_affine` proof quote | stacks-coherent.tex lines 54–134 (excerpted with `...`) | ✓ verbatim excerpts |
| `lem:cech_acyclic_affine` second proof quote | stacks-coherent.tex lines 158–173 (excerpted with `...`) | ✓ verbatim excerpts |
| `lem:cech_computes_cohomology` first quote (Tag 02KE) | stacks-coherent.tex lines 247–255 | ✓ verbatim |
| `lem:cech_computes_cohomology` second quote | stacks-coherent.tex lines 845–853 | ✓ verbatim |
| `lem:cech_computes_cohomology` proof quotes | stacks-coherent.tex lines 857–864 | ✓ verbatim |
| `def:cech_higher_direct_image` quote | stacks-coherent.tex lines 845–853 | ✓ verbatim (reused) |
| `lem:cech_flat_base_change` statement quote (Tag 02KH) | stacks-coherent.tex lines 949–969 | ✓ verbatim |
| `lem:cech_flat_base_change` proof quote | stacks-coherent.tex lines 976–1027 (excerpted) | ✓ verbatim excerpts |

**No missing citations detected. No reference-retriever spawn needed.**

Lean tag labels `lemma-cech-cohomology-quasi-coherent-trivial`, `lemma-quasi-coherent-affine-cohomology-zero`, `lemma-cech-cohomology-quasi-coherent`, `lemma-quasi-coherence-higher-direct-images-application`, `lemma-flat-base-change-cohomology` all confirmed present in `references/stacks-coherent.tex`.

### Purity

Chapter is math-only, no Lean tactic blocks or implementation prose detected. **No changes required.**

---

## Files modified

| File | Changes |
|---|---|
| `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` | 1 edit: removed `\emph{closed iter-250}` from D2′ bullet |
| `blueprint/src/chapters/Picard_LineBundleCoherence.tex` | 7 edits: removed all Lean leakage from proofs and statements |
| `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` | No changes (chapter passes purity gate) |
