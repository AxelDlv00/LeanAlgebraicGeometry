# Reference Retriever Report

## Slug
stacks-and-classical-ag-iter150

## Status
**PARTIAL** — all 11 directive slugs produced, but three of the seven Stacks-Project tag numbers the directive supplied were wrong, and three classical textbooks (Hartshorne, Eisenbud, Matsumura) are print-only and could not be fetched. Honest "could not verify" coverage written for those.

## Sources fetched

### Stacks Project (all open access, all fetched OK)

- **Tag `04QM`** — section index 33.25 "Schemes smooth over fields" — fetched OK. Note: directive expected this to be a single lemma; the actual point-statement "smooth ⇒ geometrically reduced" is **Lemma 33.25.4 = tag `056T`**, also fetched separately. Both recorded in `references/stacks-04QM.md`. **CORRECT-aligned** (just a granularity mismatch).
- **Tag `0334`** — fetched OK, **but it is Proposition 10.162.15 "Nagata rings"**, not the definition of geometrically reduced. Correct tags `035U` (schemes) and `05DS` (algebras) and `030V` (characterisations) fetched separately; content recorded in `references/stacks-0334.md`.
- **Tag `0BJF`** — fetched OK, but it is Lemma 49.3.1 (trace-pairing ⇔ étale for finite locally free), not the literal "geometrically reduced + finite ⇒ separable" statement. The intended statement is **Lemma 33.9.3 part (4) = tag `0BUG`**. Both recorded in `references/stacks-0BJF.md`.
- **Tag `02KH`** — fetched OK. Lemma 30.5.2 "Flat base change for higher direct images". **CORRECT** as the directive claimed; backs (S3.pi.1). Recorded in `references/stacks-02KH.md`.
- **Tag `0BUG`** — fetched OK. Lemma 33.9.3 — eight-part statement on A = Γ(X, 𝒪_X) for X/k proper. **CORRECT** and load-bearing for (S3.sep.1), (S3.sep.2), (S3.pi.1). Recorded in `references/stacks-0BUG.md`. **This file is the most important one in this dispatch.**
- **Tag `05DH`** — fetched OK, **but it is Lemma 38.7.4 "Localisation and universally injective maps"**, unrelated to purely inseparable extensions. Correct tags `09HD` (section 9.14) and `030K` (Lemma 9.14.6) fetched separately. Recorded in `references/stacks-05DH.md`.
- **Tag `07F4`** — fetched OK, **but it is Lemma 16.8.3 "Smoothing Ring Maps — elementary standard form"**, not the standard-smooth Ω-free statement. Correct tag `00T7` = Lemma 10.137.6 fetched separately. Recorded in `references/stacks-07F4.md`. Backs (BR.2)–(BR.5).

Supplementary tags fetched but folded into the directive-named files rather than given their own slugs:

- `056T` (Lemma 33.25.4 — smooth ⇒ geom. reduced) → folded into `stacks-04QM.md`.
- `056V` (Lemma 33.25.7 — geom. reduced ⇔ dense smooth open) → folded into `stacks-04QM.md`.
- `035U` (Section 33.6 Geometrically reduced schemes) → folded into `stacks-0334.md`.
- `05DS` (Section 10.43 Geometrically reduced algebras) → folded into `stacks-0334.md`.
- `030V` (Lemma 10.44.4 — geom. reduced equivalent characterisations) → folded into `stacks-0334.md`.
- `09HD` (Section 9.14 Purely inseparable extensions) → folded into `stacks-05DH.md`.
- `030K` (Lemma 9.14.6 — separable/purely-inseparable decomposition) → folded into `stacks-05DH.md`.
- `00T7` (Lemma 10.137.6 — standard smooth ⇒ Ω free) → folded into `stacks-07F4.md`.
- `038V` (Lemma 33.12.3 — geometrically regular characterisation) → cross-referenced inside `stacks-05DH.md`.

### Classical textbooks (paywalled)

- **Hartshorne, *Algebraic Geometry* (1977)** — Springer GTM 52 — **NOT fetched** (Springer auth-walled). Honest TOC-level stub written: `references/hartshorne-ag.md`. No theorem statements quoted; ancillary open-access lecture notes (Stein, Park) linked.
- **Eisenbud, *Commutative Algebra* (1995)** — Springer GTM 150 — **NOT fetched** (Springer auth-walled). Honest TOC-level stub written: `references/eisenbud-ca.md`.
- **Matsumura, *Commutative Ring Theory* (1989)** — CUP — chapter-level TOC fetched openly from Cambridge; section-level not verifiable. Honest stub at `references/matsumura-crt.md` with Daniel Murfet's open-access companion notes linked.

### FGA / FGA Explained (mixed open/paywall)

- **Kleiman "The Picard scheme"** — arXiv:math/0504020 + arXiv:1402.0409 — abstract + scope fetched OK from arXiv abstract page; full PDF binary not parsed (would have required PDF-to-text decoding).
- **Nitsure "Hilbert and Quot Schemes"** — arXiv:math/0504590 — abstract + scope fetched OK from arXiv abstract page.
- **Original FGA Bourbaki seminars** (Exp. 190, 195, 212, 221, 232) — **listed by indexing** but not directly verified via Numdam in this dispatch (low priority per directive's "shallow" coverage); user/writers can confirm via numdam.org.
- Recorded in `references/fga-picard.md`.

## Index updates

- `references/summary.md` — appended **11 entries** matching the 11 directive-requested slugs. The existing `challenge.lean` row is preserved. Each row is one line summarising the file's content; rows for the three "directive typo" files are clearly flagged as such.

## Notes for Dispatcher

### Critical (the planner/writers should fix the directive going forward)

1. **`0334` ≠ geometrically reduced.** It is Nagata. Correct: `035U` (schemes) / `05DS` (algebras) / `030V` (characterisations).
2. **`0BJF` ≠ "geometrically reduced + finite ⇒ separable".** It is the discriminant ⇔ étale criterion. The intended statement is **Lemma 33.9.3 part (4)** (tag `0BUG`).
3. **`05DH` ≠ purely inseparable extensions.** It is universally injective. Correct: `09HD` + `030K`.
4. **`07F4` ≠ standard smooth ⇒ Ω free.** It is a smoothing-ring-maps refinement. Correct: **`00T7`** (Lemma 10.137.6).

The blueprint chapter `RigidityKbar.tex § "Chart-algebra piece (ii) first-class decomposition"` references the directive's wrong tag numbers. Future writer rounds should **replace inline tag references** with the corrected ones above (e.g., a comment `% Stacks Project Tag 00T7` rather than `07F4` for the (BR.2)–(BR.5) bridge).

### Important (related sources the dispatcher might want next)

5. **Mathlib counterparts.** For each Stacks tag above there is a Mathlib counterpart (some present, some absent). The planner should run a `lean_local_search` audit before STRATEGY.md to determine which (S3.*) and (BR.*) claims have Mathlib backers already (`GeometricallyReduced`, `Smooth.StandardSmooth`, etc.).
6. **Tag 02O1 / Lemma 30.16.2** (asymptotic vanishing of higher direct images for very-ample tensored sheaves) was fetched as a sanity check but not packaged — it is the Serre-vanishing flavour result that *complements* `02KH` for projectivity-flavoured base-change arguments. If a future writer round generalises (S3.pi.1) beyond properness to projective + ampleness assumptions, this is the tag to cite.
7. **Tag 0BR5** (universal homeomorphisms) is the cleanest packaging for the *scheme-theoretic* purely-inseparable picture (X_{k̄} → X is a universal homeomorphism for finite purely inseparable k-algebras X). Cross-referenced inside `stacks-05DH.md`.

### Existing references/ entries

The pre-existing `references/challenge.lean` was **not modified** (read-only inspection; not within this dispatch's scope).

No pre-existing summary files contained the iter-149 fabricated content (the directive notes that file was deleted before this dispatch). `references/` is now in a clean post-fabrication state.

### Fabrication discipline observed

Every Stacks Project quote in the new files comes from a successful WebFetch on the relevant tag URL. No Hartshorne / Eisenbud quotes were synthesised: those slugs are explicit TOC-only stubs flagging the paywall, with explicit warnings to writer rounds *not* to cite specific statements through these stubs.

The Matsumura section-level table contains a clearly-marked "**NOT fully verified**" note where section-level layout was inferred from standard knowledge of the book's organisation rather than fetched directly.

---

## Return value

`stacks-and-classical-ag-iter150: PARTIAL — 11 reference files written; 4 directive tag numbers corrected; 3 print books stubbed honestly. Path: .archon/task_results/reference-retriever-stacks-and-classical-ag-iter150.md`
