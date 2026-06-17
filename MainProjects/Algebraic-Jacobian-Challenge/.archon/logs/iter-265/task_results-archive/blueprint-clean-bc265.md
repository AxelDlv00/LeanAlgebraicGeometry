# Blueprint-clean report — bc265

**Chapter:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Summary

Three targeted edits applied; file remains structurally balanced (68 `\begin{lemma}` / 68 `\end{lemma}`).

---

## Findings and actions

### 1. Tactic leakage — `\mathtt{rfl}` in `lem:pullback_tensor_map_basechange` proof (line 4198)

**Problem:** The summary paragraph of the Sq1-tail proof contained the parenthetical
`(\(\mathtt{rfl}\))` after "the Sq2 ring-map reconciliation is definitional", naming the Lean
proof term in prose. This is Lean implementation detail, not mathematical content; the prose
already conveys the meaning via the word "definitional".

**Fix:** Removed `(\(\mathtt{rfl}\))`. The sentence now reads:
> "the Sq2 ring-map reconciliation is definitional. Sq4 reduces to Sq1 …"

---

### 2. Engineering phrase — "consumed here" in `lem:dual_unit_iso` proof (line 6171)

**Problem:** The `presheafDualUnitIso` pin sentence read "The scheme-level alias of this
presheaf evaluation-at-\(1\) isomorphism consumed here is \(\mathtt{presheafDualUnitIso}\)…".
The phrase "consumed here" is proof-engineering language with no mathematical content.

**Fix:** Removed "consumed here". The sentence now reads:
> "The scheme-level alias of this presheaf evaluation-at-\(1\) isomorphism is
> \(\mathtt{presheafDualUnitIso}\)\lean{…}."

The `\lean{}` pin itself is valid and retained.

---

### 3. Sequencing language — `lem:dual_restrict_iso` proof (lines 6090–6094)

**Problem:** The sentence "The outer `isoMk` naturality square is discharged *after* — and
consumes — the per-section family naturality … the inner ε-naturality is settled first …
and only then is the outer presheaf-morphism naturality of `isoMk` assembled on top of it"
used three proof-engineering idioms ("discharged after", "consumes", "assembled on top of
it") in place of standard mathematical language.

**Fix:** Rephrased to:
> "The outer \(\mathtt{isoMk}\) naturality square follows from the per-section family
> naturality \(\mathtt{sliceDualTransport.naturality}\) of \cref{lem:slice_dual_transport}:
> the \(\varepsilon\)-naturality is established first at the level of individual sections,
> and the outer presheaf-morphism naturality of \(\mathtt{isoMk}\) then follows."

Mathematical content (the dependency ordering between inner ε-naturality and outer isoMk
naturality) is fully preserved.

---

## Structural validity — lemma balance

**Verified:** `\begin{lemma}` = 68, `\end{lemma}` = 68. File is balanced.

The blueprint writer reported a pre-existing +1 imbalance (delta 0 from its own edits).
A careful count finds no imbalance in the current file. Two explanations are consistent
with the evidence: (a) the writer's count was mistaken, or (b) the writer's addition of
`lem:leftadjointuniq_app_unit_eta_general` (one new `\begin{lemma}`/`\end{lemma}` pair)
accidentally repaired a pre-existing orphan environment whose companion `\end{lemma}` was
already present. Either way, the current file is balanced and no further action is required.

## Items confirmed clean (no edits needed)

- `lem:leftadjointuniq_app_unit_eta_general` statement and proof body (lines 3810–3843):
  all names are mathematical objects / named bricks (`leftAdjointUniq`, `homEquiv`,
  `sheafCompPb`, `leftAdjointUniqUnitEta`, etc.); no tactic language.
- The enumerate (a)–(e) for `sheafificationCompPullback_comp_tail` (lines 4116–4141):
  steps described in mathematical terms; no tactic leakage.
- The "precise binding obligation" paragraph (lines 4143–4168): uses "mechanical paste"
  and "circular (verified)" as informal mathematical descriptions, not tactic names;
  no tactic leakage.
- `lem:slice_dual_transport` proof (lines 5810–5946): all names are mathematical objects;
  `\mathtt{ModuleCat.restrictScalars.smul\_def'}` and `\mathtt{Subsingleton.elim}` are
  named lemmas (allowed); `% NOTE:` for `restrictScalarsLaxε` is a LaTeX comment.
- The `% NOTE:` at line 5935–5936 (flagging the Lean helper) is correctly formatted as
  a comment; the adjacent prose names `\mathtt{PresheafOfModules.restrictScalarsLax}\varepsilon`
  as a mathematical natural transformation (allowed and intended).
- No `\leanok`/`\mathlibok` markers were added or removed.
- No statement bodies, `\lean{}` targets, or `% SOURCE`/`% SOURCE QUOTE` blocks were
  altered.
- No other chapters were touched.
