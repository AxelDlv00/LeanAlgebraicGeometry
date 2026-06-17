# Blueprint Clean Report — tos008

**Target:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
**Edited regions audited:** `lem:slice_dual_transport_inv` prose; `lem:sheafify_tensor_unit_iso_comp` proof `\uses{}`; `lem:slice_dual_transport` step-(b) naturality paragraph.

---

## Changes Made

### Fix 1 — `lem:sheafify_tensor_unit_iso_comp` proof (was lines 3073–3076, now 3073)

**Removed** the trailing sentence:
> "Because the composite carries the `\(\mathtt{Sheaf.val}\,Z\)` carrier spelling, the rewrite of `\(\mathtt{PrPbComp}\)` into the `\(\mathtt{tensorHom}\)` is performed with `\(\mathtt{erw}\)`."

`\mathtt{erw}` is a Lean tactic. The mathematical proof is complete with the interchange-law sentence that precedes it; the dropped sentence described a Lean proof mechanism, not a mathematical step.

### Fix 2 — `lem:slice_dual_transport` step-(b) naturality (was lines 4772–4774, now 4769–4771)

**Removed** from the step-(b) paragraph:
- `(the \(\mathtt{inv}\,\varepsilon\) leg read off without \(\mathtt{whnf}\)-reduction)` — `whnf` (weak head normal form) is a Lean evaluation-strategy term with no mathematical content.
- `The prover invokes that lemma directly;` — project-history/agent narrative.

Remaining sentence reads: *"… evaluated through its proven action `\(\mathtt{dualUnitRingSwap\_apply}\)`. The thin-poset `\(\mathtt{Subsingleton.elim}\)` of (a) settles only the base morphisms."*

### Fix 3 — LaTeX typo on former line 4769

**Corrected** `\((f.\mathtt{appIso})\.\mathrm{hom}\)` → `\((f.\mathtt{appIso}).\mathrm{hom}\)`.

`\.` is a LaTeX dot-accent command; in math mode it would mis-accent `\mathrm{hom}`. Plain `.` is the intended field-access separator.

---

## Confirmations

**`hβ` hypothesis prose** (lines 5032–5043 of patched file): reads as clean mathematical prose. It states an explicit hypothesis on the composition of `β.app(op P).hom` with `(f.appIso P).hom.hom` equalling the identity, explains the hypothesis is false for a general `β`, and records that the unique call site uses `(f.appIso)^{-1}` discharged by the iso inverse law. No Lean tactic syntax.

**Step-(b) naturality reference:** all three Lean lemma names appear in `\mathtt{}` notation surrounded by mathematical description:
- `\mathtt{sliceDualTransport\_naturality\_apply}` — cited as the lemma closing the `ε`-naturality square pointwise.
- `\mathtt{appIso\_hom\_naturality\_apply}` — cited as the ring-level square that `(f.appIso).hom` intertwines restriction maps.
- `\mathtt{dualUnitRingSwap\_apply}` — cited as the proven action of the codomain swap.

None are used as tactic invocations; all have accompanying mathematical explanations.

**`unitRelabelSwap` 4th leg** (lines 5018–5026): reads as mathematical prose. Explains that `\mathtt{unitRelabelSwap}\,(\mathtt{eqToHom}\,he.\mathrm{symm})` transports the codomain unit `1_X` across the cross-fiber section-ring relabel `O_X(W') ≅ O_X(fP)`, and characterises it as the `inv ε` of that eqToHom-induced relabel. No tactic syntax.

**`\uses{}` on `lem:sheafify_tensor_unit_iso_comp` proof** (line 3066): contains `{def:sheafify_tensor_unit_iso, lem:sheafify_tensor_unit_iso_hom_eq_prime, lem:toringcatsheafhom_comp_hom_reconcile}` — all three are cited in the proof body; no dangling or missing entries.

**Source quotes:** `lem:slice_dual_transport_inv` carries the explicit note "no external reference"; `lem:sheafify_tensor_unit_iso_comp` is an internal construction. No missing `% SOURCE QUOTE:` entries required.

**`\leanok` / `\mathlibok` markers:** untouched throughout.

---

## Status

CLEAN — 3 issues fixed, no remaining Lean tactic leakage or project-history narrative in the edited regions.
