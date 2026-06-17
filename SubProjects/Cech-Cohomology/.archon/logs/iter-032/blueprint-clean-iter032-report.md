# Blueprint-clean report — iter-032

**File:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Changes made

### `lem:isLocalizedModule_of_span_cover` proof — Lean leakage stripped

Four targeted edits removed Lean-specific identifiers from the visible proof prose:

1. `(the \operatorname{IsLocalizedModule.mk} fields)` → `of its three defining conditions`  
   Removed the Lean constructor reference `.mk`.

2. `\emph{(map\_units) \(f\) acts invertibly on \(N\).}` → `\emph{\(f\) acts invertibly on \(N\).}`  
   Removed Lean structure-field label `map_units`.

3. `\emph{(surj') every \(y \in N\) satisfies …}` → `\emph{Every \(y \in N\) satisfies …}`  
   Removed Lean field label `surj'`.

4. `\emph{(exists\_of\_eq) if \(g(x) = g(x')\) …}` → `\emph{If \(g(x) = g(x')\) …}`  
   Removed Lean field label `exists_of_eq`.

All other proof content and the lemma statement are unchanged.

## Source-quote audit (new / edited blocks)

### `lem:isQuasicoherent_restrict_basicOpen`
- `% SOURCE QUOTE` (remark after `lemma-widetilde-pullback`, lines 1272–1276 of `stacks-schemes.tex`): **verbatim** ✓  
- `% SOURCE QUOTE` (from `lemma-quasi-coherent-affine` proof, lines 1298–1303): **verbatim** ✓ (double-space in "covering to  a standard" preserved)  
- `\textit{Source:}` visible line: present ✓

### `lem:isLocalizedModule_of_span_cover`
- No `% SOURCE:` block — **correct** (pure-algebra statement, no external source, per directive) ✓  
- No `\textit{Source:}` line — **correct** ✓

### `lem:qcoh_localized_sections`
- `% SOURCE QUOTE` (proof of `lemma-widetilde-pullback`, lines 1262–1268): **verbatim** ✓  
- `% SOURCE QUOTE` (remark after `lemma-widetilde-pullback`, lines 1272–1276): **verbatim** ✓  
- `\textit{Source:}` visible line: present ✓

### `lem:tilde_preserves_kernels`
- `% SOURCE QUOTE` (`lemma-kernel-cokernel-quasi-coherent` proof, lines 1425–1431): **verbatim** ✓  
- `% SOURCE QUOTE PROOF` (stalk computation, ~lines 616–629 with `…` elision): content verbatim ✓  
- `% SOURCE QUOTE PROOF` (exactness, lines 722–727): verbatim ✓  
- `\textit{Source:}` in statement block: present ✓  
- `\textit{Source:}` in proof block: present ✓

### `lem:cech_complex_hom_identification` / `lem:cech_complex_op_identification`
- Only the `\lean{}` pin lists were extended with `…Fam` helpers — no prose changes this iter.  
  Existing source quotes and `\textit{Source:}` lines unchanged and previously verified.

## `\leanok` / `\lean{}` / `\uses{}` — untouched
No markers, pins, or dependency edges were added, removed, or modified.

## Status
**CLEAN** — blueprint is math-only prose in the iter-032 blocks. No missing source quotes. All `\textit{Source:}` citations present where required.
