# Blueprint Clean Report — bc-tos261

**Chapter:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
**Scope:** Purity gate on the iter-261 edits to `lem:dual_restrict_iso` and `lem:pullback_tensor_map_basechange`.

---

## Changes Made

Two targeted edits, both confined to the recently-written `lem:dual_restrict_iso` proof (the new route-2 / `sliceDualTransport` paragraph):

### 1. Stripped "axiom-clean" project jargon (line 5775)

**Before:**
```
exactly the pattern already supplied axiom-clean for \(\mathtt{homLocalSection}\) and
\(\mathtt{dualUnitIsoGen}\).
```

**After:**
```
exactly the pattern already established for \(\mathtt{homLocalSection}\) and
\(\mathtt{dualUnitIsoGen}\).
```

"axiom-clean" is project-internal terminology (means "no additional axioms beyond Lean's kernel"). Replaced with timeless prose.

### 2. Removed Lean typeclass NOTE (lines 5785–5788)

Stripped the following `% NOTE:` comment that contained Lean-specific implementation details:

```
% NOTE: the \(\mathcal{O}_Y(V)\)-module structure on the leg-(A) source Hom is not
% auto-synthesized; it is supplied via \(\mathtt{Module.compHom}\,(\beta.\mathtt{app}\,V)\),
% restricting scalars along the open-immersion ring map
% \(\beta_V\colon \mathcal{O}_X(fV)\to\mathcal{O}_Y(V)\).
```

Reason: "auto-synthesized" is typeclass-inference jargon; `Module.compHom` and `β.app V` are Lean implementation identifiers not serving a mathematical purpose in the blueprint.

---

## Verified Intact

- **All `% SOURCE` / `% SOURCE QUOTE` comments** for `lem:dual_restrict_iso` (Stacks 01CM, lines 5658–5671) are untouched.
- **`\leanok` / `\mathlibok` markers** — not added or removed.
- **Mathematical content and `\uses` edges** — not changed.
- **The Sq2b prose of `lem:pullback_tensor_map_basechange`** (lines 3854–4089): reviewed; no Lean leakage, no project-history narrative, and no iter-260/261 references survived the writer's edits. The "missing ingredients" list correctly lists only Sq1 and Sq4; Sq2b is marked fully discharged. The `extendScalarsComp` mention at line 4032 is in a "does NOT apply" sentence and is mathematically accurate.
- **No iteration references** ("iter-260", "iter-261", "the prover proved", etc.) found in the edited regions or anywhere in the file.

---

## LaTeX Validity

No structural LaTeX issues introduced. Both edits were purely textual substitutions within `\begin{proof}…\end{proof}` blocks; no `\begin`/`\end` pairing was altered. The chapter remains self-consistent.
