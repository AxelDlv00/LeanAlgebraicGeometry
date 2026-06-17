# Blueprint-clean report — slug `ts242`

## Chapter 1: `Picard_TensorObjSubstrate.tex`

### Change made

Removed the stale `% NOTE (iter-241 review):` block (8 lines, immediately before
`\begin{lemma}` of `lem:pullback_unit_iso`). The block read:

```
% NOTE (iter-241 review): the proof prose below (the affine chart-chase, and its
% premise that `(Opens.map f.base).Final` "need not hold globally") is OBSOLETE
% and factually wrong. … Blueprint-writer to rewrite the proof to the one-liner.
% (lean-vs-blueprint ts241 + lean-auditor ts241.)
```

This was a TODO-style project-history / per-iter directive that had already been
fulfilled by writer `tos-pullback` (the proof block is now the correct one-liner).
Retaining it constitutes per-iter narrative leakage, so it was stripped.

### SOURCE QUOTE validation (`lem:pullback_tensor_iso`)

Source annotation: `references/stacks-modules.tex, L2392-2400`,
lemma `lemma-tensor-product-pullback`.

Verified byte-for-byte against `references/stacks-modules.tex` lines 2392–2400:

```
\begin{lemma}
\label{lemma-tensor-product-pullback}
Let $f : (X, \mathcal{O}_X) \to (Y, \mathcal{O}_Y)$ be
a morphism of ringed spaces. Let $\mathcal{F}$, $\mathcal{G}$
be $\mathcal{O}_Y$-modules. Then
$f^*(\mathcal{F} \otimes_{\mathcal{O}_Y} \mathcal{G})
= f^*\mathcal{F} \otimes_{\mathcal{O}_X} f^*\mathcal{G}$
functorially in $\mathcal{F}$, $\mathcal{G}$.
\end{lemma}
```

Quote in blueprint matches exactly. ✓

### Other checks

- **Lean leakage**: None found. The proof of `lem:pullback_tensor_iso` names
  Mathlib identifiers (`distribBaseChange`, `extendScalars.Monoidal`,
  `leftAdjointUniq`, `sheafificationCompPullback`) as proof ingredients;
  these are acceptable per directive.
- **Proof of `lem:pullback_unit_iso`**: Already the correct one-liner (uses
  `final_of_representablyFlat` + `instIsIsoPullbackObjUnitToUnitOfFinal`);
  `\uses` correctly set to `{def:scheme_modules_tensorobj}`.
- **Section narrative** (`sec:tensorobj_pullback_monoidality`): Clean
  mathematical prose, no tactic syntax, no iter references.

---

## Chapter 2: `Cohomology_FlatBaseChange.tex`

### No changes made

The new `lem:pullback_spec_tilde_iso` block is clean.

### SOURCE QUOTE validation (Stacks 01I9 `lemma-widetilde-pullback`)

Source annotation: `references/stacks-schemes.tex, L1241–1256`.

Verified byte-for-byte against `references/stacks-schemes.tex` lines 1241–1256:

```
\begin{lemma}
\label{lemma-widetilde-pullback}
Let
$(X, \mathcal{O}_X) = (\Spec(S), \mathcal{O}_{\Spec(S)})$,
$(Y, \mathcal{O}_Y) = (\Spec(R), \mathcal{O}_{\Spec(R)})$
be affine schemes.
Let $\psi : (X, \mathcal{O}_X) \to (Y, \mathcal{O}_Y)$ be a
morphism of affine schemes, corresponding to the ring map
$\psi^\sharp : R \to S$ (see Lemma \ref{lemma-category-affine-schemes}).
\begin{enumerate}
\item We have $\psi^* \widetilde M = \widetilde{S \otimes_R M}$
functorially in the $R$-module $M$.
\item We have $\psi_* \widetilde N = \widetilde{N_R}$ functorially
in the $S$-module $N$.
\end{enumerate}
\end{lemma}
```

Blueprint SOURCE QUOTE matches (L1243–1255 of the lemma body). ✓

### SOURCE QUOTE PROOF validation

Blueprint:
```
"The first assertion follows from the identification in
Lemma \ref{lemma-compare-constructions}
and the result of Modules, Lemma \ref{modules-lemma-restrict-quasi-coherent}."
```

Actual `references/stacks-schemes.tex` lines 1259–1261:
```
The first assertion follows from the identification in
Lemma \ref{lemma-compare-constructions}
and the result of Modules, Lemma \ref{modules-lemma-restrict-quasi-coherent}.
```

Matches exactly. ✓

### `(read from references/stacks-schemes.tex)` parenthetical

Present in the SOURCE annotation at the correct location. ✓

### Other checks

- **Lean leakage**: None. The `% NOTE:` annotations in `lem:pushforward_spec_tilde_iso`
  reference Lean identifiers (`hloc`, `IsLocalizing`, `cancelBaseChange`) but are in
  `% NOTE:` comment blocks (review-agent domain); these are left intact per policy.
- **Project-history narrative**: None in the new content.
- **`lem:affine_base_change_pushforward` expanded proof**: Clean mathematical prose
  using `cancelBaseChange` as a named Mathlib algebra ingredient. Acceptable.
- **`lem:gammaPushforwardIsoAt_naturality` demotion**: Already processed into a prose
  remark within the `lem:gammaPushforwardIsoAt` proof. No stale declaration block
  remaining.

---

## Summary

| File | Changes |
|------|---------|
| `Picard_TensorObjSubstrate.tex` | Removed 8-line stale `% NOTE (iter-241 review)` block |
| `Cohomology_FlatBaseChange.tex` | None (all quotes verified, prose clean) |

Both SOURCE QUOTEs are byte-accurate. No `\leanok`/`\mathlibok` markers were added or removed.
