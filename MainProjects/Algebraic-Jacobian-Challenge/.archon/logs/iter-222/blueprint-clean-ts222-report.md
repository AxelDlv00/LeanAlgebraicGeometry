# Blueprint-clean report — iter-222 — `lem:internal_hom_eval`

## Scope

Purity pass on `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, focused on the
`lem:internal_hom_eval` block (lines ~2608–2673) as modified by blueprint-writer ts222.

## Checks performed

### 1. Lean leakage in new prose

**Found and fixed.** The two new sentences added to the proof body contained three
instances of Lean implementation leakage:

| Location | Leakage | Fix |
|---|---|---|
| "assembled as an `\mathtt{Hom.mk}` whose app-component" | `Hom.mk` is a Lean constructor; "app-component" is a Lean natural-transformation field | Replaced with "defined by specifying, on each open \(U\)" |
| "restriction along `\mathtt{Over.map}\,g`" | `Over.map g` is a Lean categorical construct, not standard math | Replaced with "restriction to the open \(V\)" |
| "the same `\mathtt{Over.map}` coherence pattern" | Lean implementation terminology | Replaced with "restriction-functoriality argument" |

The `% NOTE:` comment (lines 2612–2618) contains Lean declaration names in `\texttt{}`
format — this is valid blueprint metadata about formalization status, not proof prose.
No change needed there.

### 2. Project-history / iteration-narrative verbosity

None found. The new prose is timeless mathematical content.

### 3. SOURCE / SOURCE QUOTE citation block

Intact and unchanged at lines 2620–2631:
- `% SOURCE: [Stacks Project], "Modules on Ringed Spaces", §Internal Hom (tag area 01CM)`
- `% SOURCE QUOTE:` with the canonical evaluation morphism display from 01CM
- `\textit{Source: ...}` rendered citation in the statement

No fabrication or alteration required.

### 4. Cross-reference resolution

`\uses{lem:presheaf_internal_hom_restriction}` in the proof block (line 2650) resolves
correctly — `\label{lem:presheaf_internal_hom_restriction}` is at line 2533 of the same
chapter. ✓

### 5. Whole-chapter scan

No additional leakage detected outside the `lem:internal_hom_eval` block.
The surrounding blocks (`def:presheaf_dual`, `lem:internal_hom_isSheaf`, etc.)
are unchanged.

## Edit applied

**File:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

**Old (lines 2660–2672, approximately):**
```
  Concretely, the morphism is assembled as an \(\mathtt{Hom.mk}\) whose
  app-component on each open \(U\) is the per-open contraction
  \((M|_U) \otimes_{R(U)} (M|_U \to R|_U) \to R(U)\), \(s \otimes \phi \mapsto \phi(s)\).
  The single remaining datum is the naturality square, which reduces to the
  evaluate/restrict-commutation identity \(\phi(s)|_V = (\phi|_V)(s|_V)\) above: the
  restriction \(\phi|_V\) of a functional inside the dual \(M^\vee\) is its further
  restriction along \(\mathtt{Over.map}\,g\), and further restriction is functorial,
  so evaluating the further-restricted functional on the restricted section agrees
  with restricting the value of the evaluation. This is the same
  \(\mathtt{Over.map}\) coherence pattern already used to make the internal-hom
  restriction maps functorial in \cref{lem:presheaf_internal_hom_restriction}. This
  is the counit of the tensor--hom adjunction of \cref{def:presheaf_internal_hom}
  specialised to the unit presheaf.
```

**New:**
```
  Concretely, the morphism is defined by specifying, on each open \(U\), the per-open
  contraction \((M|_U) \otimes_{R(U)} (M|_U \to R|_U) \to R(U)\), \(s \otimes \phi \mapsto \phi(s)\).
  The single remaining datum is the naturality square, which reduces to the
  evaluate/restrict-commutation identity \(\phi(s)|_V = (\phi|_V)(s|_V)\) above: the
  restriction \(\phi|_V\) of a functional inside the dual \(M^\vee\) is its restriction
  to the open \(V\), and restriction is functorial, so evaluating the restricted
  functional on the restricted section agrees with restricting the value of the
  evaluation. This is the same restriction-functoriality argument already used to make
  the internal-hom restriction maps functorial in
  \cref{lem:presheaf_internal_hom_restriction}. This is the counit of the tensor--hom
  adjunction of \cref{def:presheaf_internal_hom} specialised to the unit presheaf.
```

## Out-of-scope confirmations

- `\leanok` / `\mathlibok` markers: untouched ✓
- Lemma statement and `\lean{PresheafOfModules.internalHomEval}` pin: untouched ✓
- `def:presheaf_dual`, `lem:internal_hom_isSheaf`, `lem:dual_isLocallyTrivial`, and all
  other blocks: untouched ✓
- No reference retriever spawned (no missing source quote) ✓

## Status

PASS — one edit applied (Lean leakage in new proof sentences); all citations, cross-refs,
and markers verified intact.
