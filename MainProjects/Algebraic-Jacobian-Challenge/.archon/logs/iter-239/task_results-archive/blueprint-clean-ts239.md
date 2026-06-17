# blueprint-clean report — iter-239, slug `ts239`

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Scope examined
- New section `\section{Pullback-monoidality: invertibility under a general scheme morphism}` (`\label{sec:tensorobj_pullback_monoidality}`), containing `lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback`.
- Plan-agent edits to `lem:tensorobj_assoc_iso` (title "(unconditional)"; stale hypothesis note replaced).

---

## Source-quote validation

### `lem:pullback_tensor_iso` — `lemma-tensor-product-pullback`, L2392–2400

Blueprint `% SOURCE QUOTE`:
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

**Validation result: PASS** — byte-accurate match with `references/stacks-modules.tex` L2392–2400.

---

### `lem:isinvertible_pullback` — `lemma-pullback-invertible`, L4142–4147 (statement) + L4149–4157 (proof)

Blueprint `% SOURCE QUOTE` (statement):
```
\begin{lemma}
\label{lemma-pullback-invertible}
Let $f : (X, \mathcal{O}_X) \to (Y, \mathcal{O}_Y)$ be a
morphism of ringed spaces. The pullback $f^*\mathcal{L}$ of an
invertible $\mathcal{O}_Y$-module is invertible.
\end{lemma}
```

Blueprint `% SOURCE QUOTE PROOF`:
```
\begin{proof}
By Lemma \ref{lemma-invertible}
there exists an $\mathcal{O}_Y$-module $\mathcal{N}$ such that
$\mathcal{L} \otimes_{\mathcal{O}_Y} \mathcal{N} \cong \mathcal{O}_Y$.
Pulling back we get
$f^*\mathcal{L} \otimes_{\mathcal{O}_X} f^*\mathcal{N} \cong \mathcal{O}_X$
by Lemma \ref{lemma-tensor-product-pullback}.
Thus $f^*\mathcal{L}$ is invertible by Lemma \ref{lemma-invertible}.
\end{proof}
```

**Validation result: PASS** — both byte-accurate against `references/stacks-modules.tex` L4142–4147 and L4149–4157.

---

### `lem:pullback_unit_iso` — Archon-original, no source lines expected

**Validation result: PASS** — no `% SOURCE` or `% SOURCE QUOTE` lines present in the lemma block.

---

## Lean leakage

### Found and fixed

One instance of Lean-expression leakage in the proof of `lem:isinvertible_pullback`: the line

```
i.e.\ \(\mathtt{pullbackTensorIso}.\mathtt{symm} \;\ggg\;
(\mathtt{pullback}\,f).\mathtt{mapIso}\,e \;\ggg\; \mathtt{pullbackUnitIso}\),
using …
```

presented the formal Lean proof-term in Lean dot-notation with the Lean composition operator `\ggg` (`≫`), immediately after the display equation that already states the composite mathematically. This is Lean syntax in the proof sketch, not mathematical prose.

**Fix applied:** Replaced with the prose sentence:

```
This composite uses \cref{lem:pullback_tensor_iso} to commute the pullback past the
tensor and \cref{lem:pullback_unit_iso} to identify \(f^*\mathcal{O}_X\) with
\(\mathcal{O}_Y\).
```

All other uses of `\mathtt{}` in the new section are Lean-identifier names for Mathlib lemmas/instances, consistent with the project's established blueprint style throughout the chapter — not stripped.

### No other leakage found

No tactic strings, no `#print`, no `by`/`:=`/`fun` Lean syntax found elsewhere in the new section or in the `lem:tensorobj_assoc_iso` edits.

---

## Project-history verbosity

No iteration-number references, route-narrative, or ephemeral project decisions found in the new section. The intro prose and all proofs read as timeless mathematical content.

---

## `lem:tensorobj_assoc_iso` sanity check

- Title: `[Associator for $\otimes_X$ (unconditional)]` — correctly updated. ✓
- Stale `IsLocallyTrivial`-hypothesis note: replaced with a clean note explaining the hypothesis is unused and was dropped. ✓
- No `\leanok`/`\mathlibok` touched. ✓

---

## Markers

No `\leanok` or `\mathlibok` added or removed.

---

## Summary

**1 edit made** (Lean proof-term leakage stripped from `lem:isinvertible_pullback` proof).
All 3 source quotes validate byte-accurately.
`lem:pullback_unit_iso` correctly carries no source lines.
`lem:tensorobj_assoc_iso` edits pass sanity check.
Chapter is otherwise clean.
