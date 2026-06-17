# blueprint-clean iter-236 report

**Slug:** ts236  
**Status:** DONE — all issues resolved, no blockers.

---

## Chapter 1: `Picard_TensorObjSubstrate.tex`

### Writer additions reviewed
Writer `d2-balancing` added stage-(iv) balancing prose to the proof of
`lem:stalk_tensor_commutation`: stalk-level balancing identity, section-level
carrier-duality warning, and stage-(iii) bridge cross-reference (lines 1969–2028).

### Issues found and fixed

**Issue (fixed): NOTE comment with iteration-workflow verbosity**

Lines 1854–1860 contained:
```
% NOTE: forward-looking \lean{} pin — `stalkTensorIso` is NOT YET BUILT
% (the stage (v) mutual-inversion bundle, and part of stage (iv), remain).
% As of iter-235 the stage (iv) reverse-map infrastructure is landed
% axiom-clean (`revInnerLeg`, `revInner`, `revOuterLeg`, `revBihom`,
% `revBihom_germ_tmul`, all `private`); the remaining gap is the R_x-balancing
% `revBihom_balanced` and its consumer `stalkTensorRev`. Stage (v) is fully
% open. No \leanok is or should be on this block until the iso is assembled.
```

Cleaned to:
```
% NOTE: forward-looking \lean{} pin — `stalkTensorIso` is not yet assembled;
% no \leanok on this block until the isomorphism is complete.
```

Removed: "As of iter-235", "axiom-clean", private declaration names
(`revInnerLeg`, `revInner`, `revOuterLeg`, `revBihom`, `revBihom_germ_tmul`,
`revBihom_balanced`, `stalkTensorRev`), and per-stage completion status — all
pure iteration-workflow / implementation-status tracking.

### No issues in stage-(iv) prose

The prose itself (stalk-level balancing identity, carrier-duality warning,
stage-(iii) bridge) is mathematically sound and consistent with the chapter's
established style of naming constructions by their Lean build names in `\mathtt{}`
format. The use of `\mathtt{revBihom}` as the name for the bilinear map follows
the same convention as `\mathtt{stalkTensorBilin}`, `\mathtt{stalkTensorDescU}`,
etc. in stages (i)–(iii). No additional cleaning needed.

### SOURCE QUOTE integrity
The `% SOURCE QUOTE:` block for Stacks `lemma-stalk-tensor-product` (lines
1867–1882) is byte-intact and untouched.

---

## Chapter 2: `Cohomology_FlatBaseChange.tex`

### Writer additions reviewed
Writer `fbc-brick` filled `lem:pushforward_spec_tilde_iso` with a `\lean{}`
hint, a `\begin{proof}` sketch in three named steps plus a scalar-compatibility
paragraph, and a corollary remark.

### Marker check: `lem:pushforward_spec_tilde_iso`
- No `\leanok` on statement or proof block ✓ (correctly absent — new project-bespoke result)
- No `\mathlibok` ✓
- No SOURCE QUOTE (correctly absent — project-bespoke, no external source) ✓
- `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` present ✓

### Issues found and fixed

**Issue 1 (fixed): Lean declaration name `\mathrm{Scheme.}\Gamma\mathrm{SpecIso}`**

Parenthetical "(the naturality of the iso `\mathrm{Scheme.}\Gamma\mathrm{SpecIso}`)"
in the "comparison ring map" step removed. The mathematical content (the
`\Gamma \dashv \operatorname{Spec}` adjunction identifies the global-sections
map with `\varphi`) is self-contained without naming the Lean declaration.

**Issue 2 (fixed): Lean declaration name `\mathrm{fromTilde}\Gamma`**

Parenthetical "(this is the content of the counit `\mathrm{fromTilde}\Gamma`
being invertible on quasi-coherent modules)" removed. The surrounding sentence
already states the content mathematically.

**Issue 3 (fixed): Lean tactic leakage + hedging in scalar-compatibility paragraph**

Original paragraph:
> "Should a residual identity surface at the `\operatorname{ModuleCat}` level ...
> the same idiom Mathlib's own `\mathrm{Tilde}` construction uses to discharge the
> analogous `\mathrm{map\_smul}`-shaped goal."

This contained: (a) hedging language ("Should a residual identity surface"),
(b) "Mathlib's own `\mathrm{Tilde}` construction uses to discharge", and (c) the
Lean term `\mathrm{map\_smul}`-shaped goal. Replaced with a clean mathematical
statement:

> "\emph{Scalar compatibility.} The \(R\)-module structure on both sides agrees:
> the scalar action on the pushforward sections is restriction of scalars along
> \(\varphi\), which is precisely the \(R\)-module structure on
> \(\operatorname{restr}_\varphi M\). This follows from the scalar-tower identity
> along the comparison ring map \(\varphi\)."

**Issue 4 (fixed): Lean declaration name + project jargon in remark**

Remark closing:
> "— the \(\Gamma\)-fragment comparison feeding `\texttt{affineBaseChange\_pushforward\_iso}`
> and the quasi-coherence of the pushforward — this lemma is the sole remaining
> Mathlib-absent gap for the entire affine lane."

Cleaned to:
> "— the section-level module identification and the quasi-coherence of the
> pushforward — this lemma is the sole bespoke ingredient the affine lane requires."

Removed: `\texttt{affineBaseChange\_pushforward\_iso}` (Lean name in prose) and
"Mathlib-absent gap" (project jargon).

### No SOURCE QUOTE needed
The FBC brick is project-bespoke (no external source) — correctly uncited.

---

## Summary

| File | Issues fixed | Issues remaining |
|------|-------------|-----------------|
| `Picard_TensorObjSubstrate.tex` | 1 (NOTE iteration verbosity) | 0 |
| `Cohomology_FlatBaseChange.tex` | 4 (3 Lean names, 1 tactic leakage) | 0 |

Both chapters are now clean. No `\leanok`/`\mathlibok` markers were added or removed.
